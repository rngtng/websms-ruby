require 'rubygems'
require 'vcard'

$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), 'lib'))
require "websms"

config = YAML::load(File.open(File.join(File.dirname(File.dirname(__FILE__)),'config/config.yml')))

files = config['file']
default_cfg = files.delete('default')


Websms::Db::connect

def vcard
  file = File.open("contacts.vcf")
  contacts = {}
  tels = {}
  Vpim::Vcard.decode(file).each do |card|
    card.telephones.each do |t|
      contacts[Websms::Sms::clean_number(t).to_s] = card.name.fullname

      if t.location.first == 'cell'
        tels[card.name.fullname] = Websms::Sms::clean_number(t.to_s)
      end
    end
  end

  Websms::Db::Sms.find(:all,
   :conditions => "name is NOT NULL AND tel is NOT NULL",
   :select => "DISTINCT name, tel").each do |sms|
     contacts[sms.tel] = sms.name
     tels[sms.name] = sms.tel
  end

  Websms::Db::Sms.find(:all,
   :conditions => "name is NULL AND tel is NOT NULL",
   :select => "DISTINCT name, tel").each do |sms|
     if contacts[sms.tel]
       Websms::Db::Sms.update_all("name = '#{contacts[sms.tel]}'", "name IS NULL AND tel = '#{sms.tel}'")
       puts contacts[sms.tel]
     end
  end
  
  puts "####################"
  
  Websms::Db::Sms.find(:all,
   :conditions => "name is NOT NULL AND tel is NULL",
   :select => "DISTINCT name, tel").each do |sms|
     if tels[sms.name]
       Websms::Db::Sms.update_all("tel = '#{tels[sms.name]}'", "tel IS NULL AND name = '#{sms.name}'")
       puts sms.name
     end
  end

end

vcard