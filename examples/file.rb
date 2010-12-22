#!/usr/bin/env ruby

require 'rubygems'
require 'columnize'

$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), 'lib'))
require "websms"

config = YAML::load(File.open(File.join(File.dirname(File.dirname(__FILE__)),'config/config.yml')))

files = config['file']
default_cfg = files.delete('default')

Websms::Db::connect
Websms::Db::Sms.delete_all

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

  #file.each do |sms|
  #  puts Columnize::columnize sms.to_a, 160
  #end
  puts " - #{valid ? "OK" : "FAILED"}"
  content
end

# UPDATE sms SET sender_name = NULL WHERE sender_name = '';
# UPDATE sms SET receiver_name = NULL WHERE receiver_name = '';
# UPDATE sms SET receiver_tel = NULL WHERE receiver_tel = '';
# UPDATE sms SET receiver_tel = NULL WHERE receiver_tel = '';

def update_name
  Websms::Db::Sms.find(:all,
   :conditions => "receiver_name is NOT NULL AND receiver_tel is NOT NULL",
   :select => "DISTINCT *").each do |sms|
     Websms::Db::Sms.update_all("receiver_name = '#{sms.receiver_name}'", "receiver_name IS NULL AND receiver_tel = '#{sms.receiver_tel}'")
     Websms::Db::Sms.update_all("receiver_tel = '#{sms.receiver_tel}'", "receiver_tel IS NULL AND receiver_name = '#{sms.receiver_name}'")
     Websms::Db::Sms.update_all("sender_name = '#{sms.receiver_name}'", "sender_name IS NULL AND sender_tel = '#{sms.receiver_tel}'")
     Websms::Db::Sms.update_all("sender_tel = '#{sms.receiver_tel}'", "sender_tel IS NULL AND sender_name = '#{sms.receiver_name}'")
  end

  Websms::Db::Sms.find(:all,
   :conditions => "sender_name is NOT NULL AND sender_tel is NOT NULL",
   :select => "DISTINCT *").each do |sms|
     Websms::Db::Sms.update_all("receiver_name = '#{sms.sender_name}'", "receiver_name IS NULL AND receiver_tel = '#{sms.sender_tel}'")
     Websms::Db::Sms.update_all("receiver_tel = '#{sms.sender_tel}'", "receiver_tel IS NULL AND receiver_name = '#{sms.sender_name}'")
     Websms::Db::Sms.update_all("sender_name = '#{sms.sender_name}'", "sender_name IS NULL AND sender_tel = '#{sms.sender_tel}'")
     Websms::Db::Sms.update_all("sender_tel = '#{sms.sender_tel}'", "sender_tel IS NULL AND sender_name = '#{sms.sender_name}'")
  end
end
