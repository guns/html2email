require 'optparse'
require 'fileutils'
require 'html2email/html_email'
require 'html2email/html_mailer'

#
# Command line wrapper for creating and writing HtmlEmail objects
#
class Html2Email
  VERSION = '0.1.2'

  def initialize(args = [])
    @args, @options = args, { :default_type => 'str', :test_recipients => [] }
  end

  def options
    OptionParser.new do |opt|
      opt.banner = %Q{\
        Convert an html file to an email-compatible form.

        Usage: #{File.basename $0} [options] [infile[:outfile], ...]

        Options:
      }.gsub(/^ +/,'')

      opt.on('-l', '--layout FILE', 'Use FILE as a layout template') do |arg|
        @options[:layout] = File.expand_path arg
      end

      types = Tilt.mappings.keys
      opt.on('-t', '--default-type FORMAT',
             'Fall back to FORMAT when template type cannot be inferred from',
             "a file's extension, e.g. input from STDIN. " +
             "Defaults to `#{@options[:default_type]}'") do |arg|
        if types.include? arg
          @options[:default_type] = arg
        else
          raise ArgumentError, "Default type must be one of: #{types.join ', '}"
        end
      end

      opt.on('-e', '--email [ADDR,ADDR]', Array,
             'Send rendered html to recipients; list can also be defined',
             'within the template') do |arg|
        @options[:email_test] = true
        @options[:test_recipients] = arg || []
      end

      opt.on('--stdout',
             'Write to STDOUT when an outfile is not explicitly specified') do
        @options[:stdout] = true
      end

      opt.separator "\nSupported FORMATs:\n#{types.join ', '}"
    end
  end

  # Command line interface
  def run
    options.parse! @args
    messages = []

    process(@args).each do |infile, outfile|
      htmlemail = HtmlEmail.new infile, @options[:layout], @options
      write (html = htmlemail.render), outfile
      messages << html
      @options[:test_recipients] += htmlemail.test_recipients
    end

    if @options[:email_test]
      HtmlMailer.new(messages, @options[:test_recipients].uniq).html_send
    end
  ensure
    FileUtils.rm_f(@tempfile) if @tempfile
  end

  private

  def process(list)
    # read from stdin if no file args
    if list.empty?
      # both Tilt and Premailer expect files as inputs; so we use a tempfile
      @tempfile = Tempfile.new [self.class.to_s, '.' + @options[:default_type]]
      @tempfile.write $stdin.read; @tempfile.rewind
      [[@tempfile.path, $stdout]]
    else
      list.map { |a| a.split ':', 2 }.map do |infile, outfile|
        out = if outfile.nil? || outfile.empty?
          if @options[:stdout]
            $stdout
          else
            name = infile.chomp(File.extname infile)
            name << '.html' unless name[/.html$/]
            File.expand_path name
          end
        else
          File.expand_path outfile
        end
        [File.expand_path(infile), out]
      end
    end
  end

  def write(string, dst)
    if dst.kind_of? IO
      dst.write string
    else
      warn "# Writing #{dst}"
      File.open(dst, 'w') { |f| f.write string }
    end
  end
end
