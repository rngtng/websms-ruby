module Websms
  class Sms
    
    attr_accessor :id, :data, :sender_name, :sender_tel, :text
    
    def to_s
      [id, date, sender_name, sender_tel, text].join(";")
    end
  end
end