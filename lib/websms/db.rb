
module Websms
  class Db

   def import(contents, cfg)
     ActiveRecord::Base.establish_connection(cfg)

     contents.each do |content|

     end
   end

   ##############################################################################################################

   class Sms < ActiveRecord::Base
     include Websms::Sms
   end
end
