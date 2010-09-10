require 'rubygems'
#require 'ruby-debug'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require "websms"

client = Websms.new
config = YAML::load(File.open('config.yml'))
client.login(config["user"], config["password"])

smss = client.get_archive_page 3

smss.each do |sms|
  puts sms.to_s
end