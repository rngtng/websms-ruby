module Websms
  class File

    def initialize(file_name, cfg = {})
      path  = cfg.delete(:path) || ''
      @content = Array(::File.open("#{path}#{file_name}").lines).join
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

      def initialize(data = [], mapping = {})
        mapping.each do |field, key|
          send "#{field}=", eval_key(key, data)
        end
      end

      private
      def eval_key(key, data)
        key.gsub(/\$[0-9]+/) do |index|
          data[index.delete('$').to_i]
        end.strip
      end
    end

  end
end
