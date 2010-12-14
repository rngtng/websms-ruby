require 'mysql2'
require 'active_record'

module Websms
  class Db

    def self.connect(cfg_file = nil)
      return if @config_done
      file ||= ::File.join(::File.dirname(__FILE__), '../../config/config.yml')
      config = YAML::load(::File.open(file))['database'].symbolize_keys
      ActiveRecord::Base.establish_connection(config)
      @config_done = true
    end

    def self.import(contents, cfg_file = nil)
      connect(cfg_file)

      contents.each do |content|
        puts content
        sms = Websms::Db::Sms.new(content)
        sms.save!
      end
    end

    ##############################################################################################################

    class Sms < ActiveRecord::Base

    end

  end
end
