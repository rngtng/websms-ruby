
module Websms
  module Sms
    ATTRIBUTES = [:received, :sender_name, :sender_tel, :receiver_name, :receiver_tel, :date, :text, :source, :parent_msg_id]

    attr_accessor *ATTRIBUTES

    #virtual
    attr_writer   :name, :tel, :time

    ##################################

    def sender_name
      @sender_name || !received? ? @name : nil
    end

    def sender_tel
      clean_number(@sender_tel || !received? ? @tel : nil)
    end

    def receiver_name
      @receiver_name || received? ? @name : nil
    end

    def receiver_tel
      clean_number(@receiver_tel || received? ? @tel : nil)
    end

    def received?
      !@received.empty? && !eval(@received)
    end

    def date
      return Time.at(@time.to_i) if @time
      return nil if @date.nil? || @date.empty?
      DateTime.parse(@date)
    end

    # def date_human
    #   date.strftime("%m.%d.%Y %H:%M")
    # end

    def text
      @text
    end

    ##################################

    #TODO #linked_to? link_nr
    def linked?
    end

    ##################################

    def to_a
      [date, "#{sender_name}(#{sender_tel})", "#{receiver_name}(#{receiver_tel})", text.delete("\n")[0..50]]
    end

    def to_hash
      hash = {}
      ATTRIBUTES.each do |attrib|
        hash[attrib] = self.send(attrib)
      end
      hash
    end

    def to_s(joins = '|')
      to_a.join(joins)
    end

    ##################################

    def clean_number(number)
      return unless number
      number.gsub(/[^0-9]/, '').gsub('0049', '49').gsub(/^0/, '49')
    end
  end
end