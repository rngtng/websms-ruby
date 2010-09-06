require 'rubygems'
require 'nokogiri'
require 'firewatir'
require 'yaml'

$KCODE = 'UTF-8'

config   = YAML::load(File.open('config.yml'))
USER     = config["user"]
PASSWORD = config["password"]

# /Applications/Firefox.app/Contents/MacOS/firefox-bin -jssh
#           = "https://email.o2online.de/ssomanager.osp?APIID=AUTH-WEBSSO"
#LOGIN_PAGE = "http://www.o2online.de/asp/login/comcenter-login?scheme=http&port=80&server=email.o2online.de&url=%2Fssomanager.osp%3FAPIID%3DAUTH-WEBSSO"
#           = "https://email.o2online.de/ssomanager.osp?APIID=AUTH-WEBSSO&TargetApp=/smscenter_new.osp%3FAutocompletion%3D1%26SID%3D124234135_athoonis%26REF%3D1283805846%26MsgContentID%3D7855715"
LOGIN_PAGE  = "https://login.o2online.de/loginRegistration/loginAction.do?_flowId=login&o2_type=asp&o2_label=login/comcenter-login&scheme=http&port=80&server=email.o2online.de&url=%2Fssomanager.osp%3FAPIID%3DAUTH-WEBSSO"
SENT_PAGE   = "https://email.o2online.de/smscenter_search.osp?SID=124092227_otzulfav&FolderID=0&REF=1283731906&EStart="

ff = FireWatir::Firefox.new
ff.goto(LOGIN_PAGE)
ff.text_field(:name,"loginName").set(USER)
ff.text_field(:name,"password").set(PASSWORD)
ff.form(:name, "login").submit

def parse_doc( browser )
  Nokogiri::HTML(browser.html).css("table.CONTENTLIST tr").each do |elm|
    date, sender, text, dummy = elm.css("td.CONTENTTEXT")
    next unless text
    id = text.css("a").first.attributes["onclick"].value.scan(/'([^']+)'/u)[0][0]

    date = date.content.split("\n")[3].strip

    sender_name, sender_tel = if sender.css("font").any?
      sender.css("font").first.attributes["title"].value.scan(/(.+) <(.+)>/u)[0]
    else
      ["", sender.css("a").first.content.scan(/'([^']+)'/u)[0][0]]
    end

    text =  if text.css("font").any?
      text.css("font").first.attributes["title"].value
    else
      text.css("b").first.content
    end

    puts [id, date, sender_name, sender_tel, text].join(";")
  end
end

15.times do |i|
  url = "#{SENT_PAGE}#{i*50}"
  puts url
  ff.goto(url)
  parse_doc( ff )
end

# agent = Mechanize.new { |a| a.log = Logger.new("mech.log") }
# agent.get LOGIN_PAGE
# page = agent.page
#
# search_form = page.form_with(:name => "login")
#
# puts search_form.has_field?("loginName")
#
# search_form.field_with(:name => "loginName").value = USER
#
# has_field?(field_name)
# search_form.field_with(:name => "password").value = PASSWORD
#
# search_form.submit
#
# #search_results = agent.submit(search_form)
#
# #agent.get SENT_PAGE
#
# puts search_results.body
# #puts agent.page.body