require 'rubygems'
require 'bundler/setup'

require 'mechanize'

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'websms/sms'
require 'websms/o2online'
require 'websms/file'

module Websms
  VERSION = '0.2.0'
end