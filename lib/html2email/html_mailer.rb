require 'net/smtp'

class HtmlMailer
  MAX_RECIPIENTS = 10

  attr_accessor :from_addr

  def initialize(messages, list)
    @messages, @list = messages, list
    @from_addr = "do-not-reply@#{ENV['HOSTNAME'] || 'localhost'}"
  end

  def html_send
    check_recipients @list

    Net::SMTP.start('localhost') do |smtp|
      @messages.each do |html|
        smtp.send_message header(html) + html, from_addr, @list
      end
    end
  # user may not have a local mail server; let them down gentle
  rescue Errno::ECONNREFUSED
    warn '# Connection to localhost:25 refused! Is your mailserver running?'
  end

  def header(html)
    %{From: Html2Email <#{from_addr}>
      MIME-Version: 1.0
      Content-type: text/html
      Subject: Html2Email test#{title = page_title(html) && ": #{title}"}\n
    }.gsub(/^ +/,'')
  end

  def page_title(html)
    html[/<head.*?>.*?<title.*?>(.*?)<\/title>/m, 1]
  end

  def check_recipients(list)
    if list.empty?
      raise '# No recipients defined for email test!'
    elsif list.size > MAX_RECIPIENTS
      raise "# Too many recipients defined! You shouldn't need any more than " +
            MAX_RECIPIENTS.to_s
    else
      warn "# Sending test to #{list.join ', '}"
    end
  end
end
