require 'net/smtp'

module HtmlMailer
  def send(messages, list)
    check_recipients list

    Net::SMTP.start('localhost') do |smtp|
      messages.each do |html|
        smtp.send_message header(html) + html, from_addr, list
      end
    end
  # user may not have a local mail server; let them down gentle
  rescue Errno::ECONNREFUSED
    warn '# Connection to localhost:25 refused! Is your mailserver running?'
  rescue
    warn $!.to_s
    return nil
  end

  private

  def from_addr
    "do-not-reply@#{ENV['HOSTNAME'] || 'localhost'}"
  end

  def header(html)
    %{From: Html2Email <#{from_addr}>
      MIME-Version: 1.0
      Content-type: text/html
      Subject: Html2Email test: #{page_title html}\n
    }.gsub(/^ +/,'')
  end

  def page_title(html)
    html[/<head.*?>.*?<title.*?>(.*?)<\/title>/m, 1]
  end

  def check_recipients(list)
    if list.empty?
      raise '# No recipients defined for email test!'
    elsif list.size > 10
      raise "# Too many recipients defined! You shouldn't need more than ten"
    else
      warn "# Sending test to #{list.join ', '}"
    end
  end
end
