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
    reg =~ /&gt/ ? /'(.+) &lt;(.*)&gt;,'/ : /'()(.+)'/
    data.scan(reg)[0]
    #sender_name, sender_tel = if sender.css("font").any?
    #  sender.css("font").first.attributes["title"].value.scan(/(.+) <(.+)>/u)[0]
    #else
    #  ["", sender.css("a").first.content.scan(/'([^']+)'/u)[0][0]]
    #end

    #sender_name, sender_tel = if sender.css("font").any?
    #  sender.css("font").first.attributes["title"].value.scan(/(.+) &lt;(.+)&gt;/u)[0]
    #else
    #  ["", sender.css("a").first.content.scan(/'([^']+)'/u)[0][0]]
    #end
  end

  def text
    # @text ||=  if @raw_text.css("font").any?
    #   text.css("font").first.attributes["title"].value
    # else
    #   text.css("b").first.content if text.css("b").first
    # end

    # if text.size > 90
    #   url = "#{EDIT_PAGE}#{id}"
    #   # text = html(url)
    #   @browser.goto(url)
    #   @browser.frame(:name, "frame_content").document
    #   text = @browser.html.scan(/<textarea[^>]+>([^<]*)</)[1][0]
    #   # debugger
    #   # .css("textarea.LARGE").first.content
    # end
  end
  
  def to_s
    [id, date, sender, text].join(";")
  end
end