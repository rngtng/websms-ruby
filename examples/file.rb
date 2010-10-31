require 'rubygems'

$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), 'lib'))
require "websms"

config = YAML::load(File.open(File.join(File.dirname(__FILE__),'config.yml')))


files = config['file']
default_cfg = files.delete(:default)
files.map do |file_name, cfg|
  next unless cfg
  cfg = default_cfg.merge( cfg )
  next unless cfg[:enabled]

  print "#{file_name}"

  file_name = File.join(cfg[:path], file_name)

  file = Websms::File.new(file_name, cfg)

  i = 0
  file.parse.each do |sms|
    #puts sms
    i += 1
  end

  if test_pattern = cfg[:test]
    size = `grep -E '#{test_pattern}' #{file_name} | wc -l`.strip.to_i
  end

  print " (#{i}/#{size}) - "
  puts (i != size) ? "FAILED" : "OK"

end
