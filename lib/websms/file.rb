require 'ruby-debug'

module Websms
  class File

    def initialize(file_name, cfg = {})
      @content = Array(::File.open(file_name).lines).join
      @pattern = Regexp.new cfg.delete(:pattern).to_s
      @split   = cfg.delete(:split)
      @mapping = cfg.delete(:mapping)
    end

    def parse
      split_content.map do |data|
        Websms::File::Sms.new(data, @mapping)
      end
    end

    def split_content
      return @content.split("\n").map { |line| line.split(@split) } if @split
      #debugger
      @content.scan(@pattern)
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
