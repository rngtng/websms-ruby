
module Websms
  module Sms

    attr_accessor :id, :date, :time, :text
    attr_writer   :received, :name, :tel, :sender_name, :sender_tel, :receiver_name, :receiver_tel

    attr_accessor :source
    attr_accessor :partent_id

    def to_a
      [date, "#{sender_name}(#{sender_tel})", "#{receiver_name}(#{receiver_tel})", text.delete("\n")[0..50]]
    end

    def to_s(joins = '|')
      to_a.join(joins)
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

    def date
      return Time.at(@time.to_i).strftime("%m.%d.%Y %H:%M") if @time
      return nil if @date.nil? || @date.empty?
      DateTime.parse(@date).strftime("%m.%d.%Y %H:%M")
    end

    #TODO #linked_to? link_nr
    def linked?
    end

  end
end