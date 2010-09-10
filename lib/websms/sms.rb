class Websms
  
  class Sms
    def initialize(raw_date, raw_sender, raw_text, account)
      @raw_date   = raw_date
      @raw_sender = raw_sender
      @raw_text   = raw_text
      @account    = account
    end

    def id
      @id ||= @raw_text.css("a").first.attributes["onclick"].value.scan(/'([^']+)'/u)[0][0]
    end

    def date
      return @date if @date
      #date = date.content.split("\n")[3].strip
      day, month, year, hour, minute = @raw_date.content.scan(/\('([^)]*)'\)/).first.first.split("', '")
      @date = "#{day}.#{month}.#{year} #{hour}:#{minute}"
    end

    def sender_name
      @sender_name ||= sender.first
    end
  
    def sender_tel
      @sender_tel ||= sender.last
    end
    
    def sender
      return @sender if @sender
      data = @raw_sender.content
      reg = (data =~ /&gt/) ? /'(.+) &lt;(.*)&gt;,'/ : /'()(.+)'/
      @sender = data.scan(reg)[0]
    end

    def text
      return @text if @text
      @text = @raw_text.content.scan(/cleanMessage\('(.*)'\),/)[0][0]
      @text = long_text if @text.size > 90
      @text
    end
  
    def long_text
      @raw_text = @account.get_edit_page(id)
      @raw_text.parser.css("textarea.LARGE").first.content
    end
  
    def to_s
      [id, date, sender_name, sender_tel, text].join(";")
    end
  end
  
end