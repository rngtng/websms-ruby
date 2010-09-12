require 'mechanize'

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'websms/sms'
require 'websms/o2online'

module Websms
  VERSION = '0.2.0'
  
  PER_PAGE     = 50

  #attr_accessor :browser

end