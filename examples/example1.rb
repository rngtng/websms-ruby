require 'rubygems'
#require 'ruby-debug'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require "websms"

config = YAML::load(File.open('config.yml'))

browser = Websms::O2online.new
browser.login(config["user"], config["password"])

smss = browser.get_archive_page 3

smss.each do |sms|
  puts sms.to_s
end