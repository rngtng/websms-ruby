#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path('../lib')
require 'websms/o2online'
require 'yaml'

CFG_FILE = File.expand_path('../../config/config.yml')

config = YAML::load(File.open(CFG_FILE))["o2online"]

browser = Websms::O2online.new
browser.login(config["user"], config["password"])

if browser.logged_in?
  raw = browser.get_archive_page 3
  debugger
end

# sms = Websms::Sms.extract(raw, :mapping => config["mapping"], :pattern => config["pattern"])

#sms.each do |s|
 # Websms::Sms.create(s)
#end
