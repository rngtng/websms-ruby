class SMS
  def initialize( raw_date, raw_sender, raw_text )
    @raw_date = raw_date
    @raw_sender = raw_sender
    @raw_text = raw_text
  end

  def id
    @id ||= @raw_text.css("a").first.attributes["onclick"].value.scan(/'([^']+)'/u)[0][0]
  end

  def date
    #date = date.content.split("\n")[3].strip
    day, month, year, hour, minute = @raw_date.content.scan(/\('([^)]*)'\)/).first.first.split("', '")
    "#{day}.#{month}.#{year} #{hour}:#{minute}"
  end

  def sender_name
    @sender_name ||= sender.first
  end
  
  def sender_tel
    @sender_tel ||= sender.last
  end
    
  def sender
    data = @raw_sender.content
    reg = (data =~ /&gt/) ? /'(.+) &lt;(.*)&gt;,'/ : /'()(.+)'/
    data.scan(reg)[0]
  end

  def text
    @text = @raw_text.content.scan(/cleanMessage\('(.*)'\),/)[0][0]
 #   @text = long_text if @text.size > 90
  end
  
  def long_text
    @text
#    @raw_text.content
    #   url = "#{EDIT_PAGE}#{id}"
    #   # text = html(url)
    #   @browser.goto(url)
    #   @browser.frame(:name, "frame_content").document
    #   text = @browser.html.scan(/<textarea[^>]+>([^<]*)</)[1][0]
    #   # debugger
    #   # .css("textarea.LARGE").first.conten
  end
  
  def to_s
    [id, date, sender_name, sender_tel, text].join(";")
  end
end