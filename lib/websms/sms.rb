module Websms
  class Sms
    
    attr_accessor :id, :date, :sender_name, :sender_tel, :receiver_name, :receiver_tel, :text
    attr_accessor :source
    attr_accessor :partent_id
    
    def to_s( joins = ";")
      [id, date, sender_name, sender_tel, receiver_name, receiver_tel, text].join(joins)
    end
  end
end