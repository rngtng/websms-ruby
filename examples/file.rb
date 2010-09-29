require 'rubygems'

$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), 'lib'))
require "websms"

config = YAML::load(File.open(File.join(File.dirname(__FILE__),'config.yml')))

files = config['file']
default_cfg = files.delete(:default)
files.map do |file_name, cfg|
  next unless cfg
  cfg = default_cfg.merge( cfg )
  next unless cfg[:enabled]
  
  file_name = File.join(cfg[:path], file_name)
  puts "#{file_name}"
  
  file = Websms::File.new(file_name, cfg)
  
  file.parse.each do |sms|
    puts sms
  end
end