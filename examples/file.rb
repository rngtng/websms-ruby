require 'rubygems'

$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), 'lib'))
require "websms"

config = YAML::load(File.open(File.join(File.dirname(__FILE__),'config.yml')))


config['file'].map do |file_name, cfg|
  next unless file_name == "SMS-2004-11-30.txt"
  file = Websms::File.new(file_name, cfg)
  puts "#{file_name}"
  file.parse.each do |sms|
    puts sms
  end
end