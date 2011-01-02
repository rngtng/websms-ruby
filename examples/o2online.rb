#!/usr/bin/env ruby

require 'rubygems'

$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), 'lib'))
require "websms"

config = YAML::load(File.open(File.join(File.dirname(File.dirname(__FILE__)),'config/config.yml')))

browser = Websms::O2online.new
browser.login(config["o2online"]["user"], config["o2online"]["password"])

smss = browser.get_archive_page 3

smss.each do |sms|
  puts sms.to_s
end