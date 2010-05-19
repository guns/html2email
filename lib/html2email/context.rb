require 'rack/utils'

#
# Templates are evaluated in the scope of Context.new
#
class Context
  include Rack::Utils
  alias_method :h, :escape_html

  class PrebindingException < StandardError; end

  class Attr < Hash
    def to_s
      self.map { |k,v|
        "#{Rack::Utils.escape_html k}='#{Rack::Utils.escape_html v}'"
      }.join(' ')
    end
  end

  def initialize
    @binding, @test_recipients = nil, []
  end

  def prebinding(&block)
    return if @binding
    @binding = (block.call; binding)
    raise PrebindingException
  end

  attr_accessor :test_recipients
  def add_test_recipients(*list)
    @test_recipients += list.flatten
  end

  def link_to(text, url, opts = {})
    %Q(<a href='#{h url}' target='_blank' #{Attr[opts]}>#{text}</a>)
  end

  def image_tag(src, opts = {})
    %Q(<img src='#{h src}' #{Attr[opts]} />)
  end
end
