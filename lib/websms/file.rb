module Websms
  class File

    def initialize(file_name, cfg = {})
      @content = Array(File.open(file_name).lines).join
      @pattern = Regexp.new cfg.delete(:pattern)
      @mapping  = cfg.delete(:mapping)
    end
    
    def parse
      @content.scan(@pattern).map do |sms_data|
        Websms::File::Sms.new(sms_data, @mapping)
      end
    end

    ##############################################################################################################

    class Sms < Websms::Sms

      def initialize(data, mapping)
        mapping.each do |field, key|
          data = data[key] || key if data[key] || string?(key)
          send("#{field}=", data)
        end
      end

      private
      def string?(str)
        str.to_i.to_s == str
      end
    end
    
  end
end
