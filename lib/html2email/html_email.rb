require 'tempfile'
require 'tilt'
require 'premailer'
require 'html2email/context'

class HtmlEmail
  attr_accessor :options

  def initialize(template, layout = nil, options = {})
    @template, @layout, @options = template, layout, options
    @options[:default_type] ||= 'str'
    @test_recipients = []
    @context = Context.new
  end

  # returns converted html string
  def render
    buf = if @layout
      # run through template once to catch prebinding block
      begin
        tilt_render @template
      rescue Context::PrebindingException
      rescue
        # some other StandardError was raised, probably a NameError;
        # reset the context to minimize the leaky abstraction
        @context = Context.new
      end
      # return the full render with the new lexical binding
      tilt_render(@layout) { tilt_render @template }
    else
      tilt_render @template
    end
    inline_css buf
  end

  def test_recipients
    @context.test_recipients
  end

  private

  def tilt_render(file)
    klass = Tilt[file] || Tilt.mappings[@options[:default_type]]
    klass.new(file).render(@context) { yield if block_given? }
  end

  def inline_css(html)
    # Premailer only works on files, hence the tempfile
    base = File.expand_path(File.dirname(@layout || @template))
    # any relative links are resolved by Premailer relative to the filepath
    Tempfile.open(self.class.to_s, base) do |tmp|
      html = inject_css html, @options[:stylesheet]
      tmp.write html; tmp.rewind
      pre = Premailer.new tmp.path, :warn_level => Premailer::Warnings::RISKY
      pre.warnings.each do |w|
        warn "#{w[:message]} (#{w[:level]}) " +
             "may not render properly in #{w[:clients]}"
      end
      pre.to_inline_css
    end
  end

  def inject_css(html, stylesheet)
    return html if stylesheet.nil? || !File.exist?(stylesheet)
    # embed stylesheet in <head> tag
    css = tilt_render @options[:stylesheet]
    css = "<style type='text/css' media='screen'>#{css}</style>"
    html.sub /(<head.*?>)/, '\1' + css
  end
end
