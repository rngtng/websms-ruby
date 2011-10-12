
module Websms
  class Sms
    ATTRIBUTES = [:received,
                  :rname, :rtel,
                  :sname, :stel,
                  :date, :day, :month, :year, :hour, :minute, :text,
                  :source, :parent_msg_id,
                  :status,
                  :id]

    attr_accessor *ATTRIBUTES
    attr_accessor :attributes

    ##################################

    def initialize(options = {})
      self.attributes = {}
      #update_attributes(options)
    end

    ##################################

    def self.clean_number(number)
      return unless number
      number.gsub(/[^0-9]/, '').gsub('0049', '49').gsub(/^0/, '49')
    end

    ##################################

    def fill(data, pattern)
      if match = data.match(/#{pattern}/mix)
        match.names.each do |name|
          update_attribute(name, match[name])
        end
      end
    end

    ##################################

    private
    def update_attributes(options)
      options.each do |name, value|
        update_attribute(name, value)
      end
    end

    def update_attribute(name, value)
      attributes[name] = value
      # send("#{name}=", value)
    end

  end
end

=begin
    def tel
      Websms::Sms::clean_number(@tel)
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
      [date, "#{name}(#{tel})", text.delete("\n")[0..50]]
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

  end
end

=end
