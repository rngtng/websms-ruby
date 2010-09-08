require 'rubygems'
require 'nokogiri'
require 'yaml'
require 'iconv'

require 'ruby-debug'

config   = YAML::load(File.open('config.yml'))
USER     = config["user"]
PASSWORD = config["password"]

LOGIN_PAGE  = "https://login.o2online.de/loginRegistration/loginAction.do?_flowId=login&o2_type=asp&o2_label=login/comcenter-login&scheme=http&port=80&server=email.o2online.de&url=%2Fssomanager.osp%3FAPIID%3DAUTH-WEBSSO"
SENT_PAGE   = "https://email.o2online.de/smscenter_search.osp?SID=124092227_otzulfav&FolderID=0&REF=1283731906&EStart="
EDIT_PAGE   = "https://email.o2online.de/ssomanager.osp?APIID=AUTH-WEBSSO&TargetApp=/smscenter_new.osp%3FAutocompletion%3D1%26SID%3D124234135_athoonis%26REF%3D1283811721%26MsgContentID%3D"

# /Applications/Firefox.app/Contents/MacOS/firefox-bin -jssh
# require 'firewatir'
# @browser = FireWatir::Firefox.new
# @browser.goto(LOGIN_PAGE)
# @browser.text_field(:name,"loginName").set(USER)
# @browser.text_field(:name,"password").set(PASSWORD)
# @browser.form(:name, "login").submit

require 'mechanize'
@browser = Mechanize.new { |agent|
    agent.follow_meta_refresh = true
  }

@browser.get LOGIN_PAGE

page = @browser.page.form_with(:name => "login") do |form|
  form.field_with(:name => "loginName").value = USER
  form.field_with(:name => "password").value = PASSWORD
end.submit 

#_eventId_login

#@browser.submit(form, form.buttons.last)


debugger

@browser.get SENT_PAGE

#search_form.submit

# search_form.submit
#
# #search_results = agent.submit(search_form)
#
# #agent
#
# puts search_results.body
# #puts agent.page.body


def parse_doc( doc )
  doc.css("table.CONTENTLIST tr").each do |elm|
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

    if text.size > 90
      url = "#{EDIT_PAGE}#{id}"
      # text = html(url)
      @browser.goto(url)
      @browser.frame(:name, "frame_content").document
      text = @browser.html.scan(/<textarea[^>]+>([^<]*)</)[1][0]
      # debugger
      # .css("textarea.LARGE").first.content
    end
    
    puts [id, date, sender_name, sender_tel, text].join(";")
  end
end

def html(url)
  @browser.goto(url)
  Nokogiri::HTML(Iconv.conv('ISO-8859-1', 'utf-8', @browser.html))
end


15.times do |i|
  url = "#{SENT_PAGE}#{i*50}"
  parse_doc html(url)
end