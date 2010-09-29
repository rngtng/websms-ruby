module Websms
  class Sms

    attr_accessor :id, :date, :text
    attr_writer   :received, :name, :tel, :sender_name, :sender_tel, :receiver_name, :receiver_tel

    attr_accessor :source
    attr_accessor :partent_id

    def to_s(joins = '|')
      #[received?, date, sender_name, sender_tel, receiver_name, receiver_tel, text[0..20]].join(joins)
      [received?, date, sender_tel, receiver_tel, text[0..25]].join(joins)
    end

    def sender_name
      @sender_name || !received? ? @name : nil
    end

    def sender_tel
      @sender_tel || !received? ? @tel : nil
    end

    def receiver_name
      @receiver_name || received? ? @name : nil
    end

    def receiver_tel
      @receiver_tel || received? ? @tel : nil
    end

    def received?
      !@received.empty? && !eval(@received)
    end

    #TODO #linked_to? link_nr
    def linked?
    end

  end
end