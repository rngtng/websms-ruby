
module Websms
  module Sms
    ATTRIBUTES = [:received, :name, :tel, :date, :text, :source, :parent_msg_id]

    attr_accessor *ATTRIBUTES

    #virtual
    attr_writer :time

    ##################################

    def tel
      clean_number(@tel)
    end

    def received
      !!eval(@received) || 0
    end

    def received?
      received
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
        value = self.send(attrib)
        hash[attrib] = value.blank? ? nil : value
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