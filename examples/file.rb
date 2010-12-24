#!/usr/bin/env ruby

require 'rubygems'
require 'columnize'

$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), 'lib'))
require "websms"

@config = YAML::load(File.open(File.join(File.dirname(File.dirname(__FILE__)),'config/config.yml')))

Websms::Db::connect

def import
  Websms::Db::Sms.delete_all
  files = @config['file']
  default_cfg = files.delete('default')
  files.map do |file_name, cfg|
    next unless cfg
    cfg = default_cfg.merge( cfg )
    next unless cfg['enabled']

    print "#{file_name} - "

    file_name = File.join(cfg['path'], file_name)
    content = Websms::File::import(file_name, cfg)

    content.each do |sms|
      Websms::Db::Sms.new(sms.to_hash).save!
    end

    valid   = Websms::File::valid?(file_name, cfg, content)

    puts " - #{valid ? "OK" : "FAILED"}"
    content
  end
end

def update_name
  Websms::Db::Sms.find(:all,
   :conditions => "name is NOT NULL AND tel is NOT NULL",
   :select => "DISTINCT name, tel").each do |sms|
     Websms::Db::Sms.update_all("name = '#{sms.name}'", "name IS NULL AND tel = '#{sms.tel}'")
     Websms::Db::Sms.update_all("tel = '#{sms.tel}'", "tel IS NULL AND name = '#{sms.name}'")
  end
end

import
update_name
