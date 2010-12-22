#require 'ruby-debug'

module Websms
  class File

    def self.import(file_name, cfg = {})
      raw_content = Array(::File.open(file_name).lines).join
      pattern     = Regexp.new cfg.delete('pattern').to_s
      mapping     = cfg.delete('mapping')

      i = 0
      @content    = split_content(raw_content, pattern, cfg.delete('split')).map do |data|
        mapping["source"] = "#{file_name}-#{i+=1}"
        Websms::File::Sms.new(data, mapping)
      end
    end

    def self.split_content(content, pattern, split)
      return content.split("\n").map { |line| line.split(split) } if split
      content.scan(pattern)
    end

    def self.valid?(file_name, cfg = {}, content = nil)
      test_pattern = cfg.delete('test')
      content      ||= import(file_name, cfg)
      size           = `grep -E '#{test_pattern}' #{file_name} | wc -l`.strip.to_i
      print "is: #{content.size} should:#{size}"
      content.size == size
    end

    ##############################################################################################################

    class Sms
      include Websms::Sms

      def initialize(data = [], mapping = {})
        mapping.each do |field, key|
          send "#{field}=", eval_key(key, data)
        end
      end

      private
      def eval_key(key, data)
        return key.to_s unless key.is_a?(String)
        key.gsub(/\$[0-9]+/) do |index|
          data[index.delete('$').to_i]
        end.strip
      end
    end

  end
end
