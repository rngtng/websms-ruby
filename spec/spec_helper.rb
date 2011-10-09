#
#  Copyright (c) 2011, SoundCloud Ltd., Rany Keddo, Tobias Bielohlawek
#

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

#require 'active_record'
require 'websms'

# use memroy DB here??

# ActiveRecord::Base.establish_connection(
#   :adapter => 'mysql',
#   :database => 'large_hadron_migration',
#   :username => 'root',
#   :password => '',
#   :host => 'localhost'
# )