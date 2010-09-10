require 'mechanize'

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'websms/sms'
#require 'o2online/client'

class Websms
  VERSION = '0.2.0'
  
  LOGIN_PAGE   = "https://login.o2online.de/loginRegistration/loginAction.do?_flowId=login&o2_type=asp&o2_label=login/comcenter-login&scheme=http&port=80&server=email.o2online.de&url=%2Fssomanager.osp%3FAPIID%3DAUTH-WEBSSO"
  ARCHIVE_PAGE = "https://email.o2online.de/smscenter_search.osp?SID=124092227_otzulfav&FolderID=0&REF=1283731906&EStart="
  EDIT_PAGE    = "https://email.o2online.de/smscenter_new.osp?Autocompletion=1&SID=124683602_emgucyuj&REF=1284069078&MsgContentID="
  
  PER_PAGE     = 50

  def initialize
    @browser = Mechanize.new do |agent|
      agent.follow_meta_refresh = true
    end
    
    @logged_in = false
  end

  def login(user, password)
    @browser.get LOGIN_PAGE

    form = @browser.page.form_with(:name => "login")
    form.field_with(:name => "loginName").value = user
    form.field_with(:name => "password").value = password
    @browser.submit(form, form.buttons.last)
    @logged_in = true # TODO better grap for content
  end

  attr_accessor :browser
  
  def logged_in?
    @logged_in
  end

  #alias sent?
  #cache + force to reload
  def archive
  end

  #private
  def get_edit_page(id)
    @browser.get "#{EDIT_PAGE}#{id}"
  end

  def get_archive_page( page_nr = 1 )
    parse_archive @browser.get "#{ARCHIVE_PAGE}#{page_nr*PER_PAGE}"
  end

  def parse_archive( archive )
    archive.parser.css("table.CONTENTLIST tr").map do |line|
      parse_archive_line line
    end.compact
  end

  def parse_archive_line( line )
    date, sender, text, dummy = line.css("td.CONTENTTEXT")
    text ? Sms.new(date, sender, text, self) : nil
  end

end