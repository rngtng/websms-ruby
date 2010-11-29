require 'rubygems'
require 'columnize'

$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), 'lib'))
require "websms"

Websms::Db::init

content = [ {:sender_name => 'test' } ]
Websms::Db::import(content)
