require 'rubygems'
require 'columnize'

$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), 'lib'))
require "websms"

config = YAML::load(File.open(File.join(File.dirname(File.dirname(__FILE__)),'config/config.yml')))

files = config['file']
default_cfg = files.delete('default')

Websms::Db::connect

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
  puts "#{content.size} - #{valid ? "OK" : "FAILED"}"
  content
end
