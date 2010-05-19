require 'optparse'
require 'fileutils'
require 'tempfile'
require 'net/smtp'
require 'tilt'
require 'html2email/html_email'

#
# Command line wrapper for creating and writing HtmlEmail objects
#
class Html2Email
  VERSION = '0.1.1'

  def initialize(args = [])
    @args, @opts = args, { :default_type => 'str', :test_recipients => [] }
  end

  def options
    OptionParser.new do |opt|
      opt.banner = %Q{\
        Convert an html file to an email-compatible form.

        Usage: #{File.basename $0} [options] [infile[:outfile], ...]

        Options:
      }.gsub(/^ +/,'')

      opt.on('-l', '--layout FILE', 'Use FILE as a layout template') do |arg|
        @opts[:layout] = File.expand_path arg
      end

      opt.on('-c', '--css STYLESHEET',
             'Embed styles from STYLESHEET, which can be written in any of the',
             'supported FORMATs. Styles are inserted at the top of the <head>',
             'element, so that element must be present.',
             'Note that any CSS files referenced by link[rel=stylesheet]',
             'elements are automatically included and embedded') do |arg|
        @opts[:stylesheet] = File.expand_path arg
      end

      mappings = Tilt.mappings.keys.join(', ')
      opt.on('-t', '--default-type FORMAT',
             'Fall back to FORMAT when template type cannot be inferred from',
             "a file's extension, e.g. input from STDIN. " +
             "Defaults to `#{@opts[:default_type]}'") do |arg|
        if Tilt.mappings.keys.include? arg
          @opts[:default_type] = arg
        else
          raise ArgumentError, "Default type must be one of: #{mappings}"
        end
      end

      opt.on('-e', '--email [addr,addr]', Array,
             'Email rendered html to recipients; list can also be defined',
             'within the template') do |arg|
        @opts[:send_test] = true
        @opts[:test_recipients] = arg || []
      end

      opt.separator "\nSupported FORMATs:\n#{mappings}"
    end
  end

  # Command line interface
  def run
    options.parse! @args

    messages = []
    process(@args).each do |infile, outfile|
      htmlemail = HtmlEmail.new(infile, @opts[:layout], @opts)
      write (html = htmlemail.render), outfile
      messages << [File.basename(infile), html]
      @opts[:test_recipients] += htmlemail.test_recipients
    end

    send_test messages, @opts[:test_recipients] if @opts[:send_test]
  rescue
    abort $!.to_s
  ensure
    FileUtils.rm_f(@tempfile) if @tempfile
  end

  private

  def process(list)
    # read from stdin if no file args
    if list.empty?
      # both Tilt and Premailer expect files as inputs; so we use a tempfile
      @tempfile = Tempfile.new [self.class.to_s, '.' + @opts[:default_type]]
      @tempfile.write $stdin.read; @tempfile.rewind
      [[@tempfile.path, $stdout]]
    else
      list.map { |a| a.split(':', 2) }.map do |i,o|
        # default to file minus extname if no output file specified
        (o.nil? || o.empty?) && o = (i[/.html$/] ? i : i.chomp(File.extname i))
        [File.expand_path(i), File.expand_path(o)]
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

  def send_test(messages, list)
    if list.empty?
      warn '# No recipients defined for email test!'
      return
    elsif list.size > 10
      warn "# Too many recipients defined! You shouldn't need more than ten"
      return
    else
      warn "# Sending test to #{list.join ', '}"
    end

    page_title = lambda { |s| s[/<head.*?>.*?<title.*?>(.*?)<\/title>/m, 1] }
    from_addr = "do-not-reply@#{ENV['HOSTNAME'] || 'localhost'}"

    begin
      Net::SMTP.start('localhost') do |smtp|
        messages.each do |file, html|
          header = %Q{\
            From: #{self.class} <#{from_addr}>
            MIME-Version: 1.0
            Content-type: text/html
            Subject: #{self.class} test: #{page_title.call html}\n
          }.gsub(/^ +/,'')

          smtp.send_message header + html, from_addr, list
        end
      end
    # user may not have a local mail server; let them down gentle
    rescue Errno::ECONNREFUSED
      warn '# Connection to localhost:25 refused! Is your mailserver running?'
    end
  end
end
