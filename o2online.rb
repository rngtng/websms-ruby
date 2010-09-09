require 'rubygems'
#require 'nokogiri'
require 'yaml'
#require 'iconv'

require 'ruby-debug'

config   = YAML::load(File.open('config.yml'))
USER     = config["user"]
PASSWORD = config["password"]

b = O2online.new
b.login(USER, PASSWORD)

b.get_page

# /Applications/Firefox.app/Contents/MacOS/firefox-bin -jssh
# require 'firewatir'
# @browser = FireWatir::Firefox.new
# @browser.goto(LOGIN_PAGE)
# @browser.text_field(:name,"loginName").set(USER)
# @browser.text_field(:name,"password").set(PASSWORD)
# @browser.form(:name, "login").submit

# 15.times do |i|

 
# end
#debugger

