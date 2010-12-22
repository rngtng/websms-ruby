#!/usr/bin/env ruby

require 'rubygems'

$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), 'lib'))
require "websms"

config = YAML::load(File.open(File.join(File.dirname(__FILE__),'config.yml')))



browser = Websms::O2online.new
browser.login(config["user"], config["password"])

smss = browser.get_archive_page 3

smss.each do |sms|
  puts sms.to_s
end