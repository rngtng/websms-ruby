require 'rubygems'
require 'columnize'

$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), 'lib'))
require "websms"

config = YAML::load(File.open(File.join(File.dirname(__FILE__),'config.yml')))


content = []
Websms::File::import(content, config['database'].symbolize_keys)

