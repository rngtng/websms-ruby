require 'mechanize'

module Websms
  class O2online

    LOGIN_PAGE   = "https://login.o2online.de/auth/login?o2_type=asp&o2_label=login/comcenter-login&scheme=http&port=80&server=email.o2online.de&url=%2Fssomanager.osp%3FAPIID%3DAUTH-WEBSSO"
    LOGIN_SUCCESS_PAGE = "https://login.o2online.de/auth/?wicket:interface=:1::::"

    INDEX_PAGE = "https://email.o2online.de/ssomanager.osp?APIID=AUTH-WEBSSO"

    NEW_PAGE     = "https://email.o2online.de/ssomanager.osp?APIID=AUTH-WEBSSO&TargetApp=/smscenter_new.osp%3FAutocompletion%3D1%26MsgContentID%3D-1"
    EDIT_PAGE    = "https://email.o2online.de/smscenter_new.osp?Autocompletion=1&SID=124683602_emgucyuj&REF=1284069078&MsgContentID="
    ARCHIVE_PAGE = "https://email.o2online.de/smscenter_search.osp"

    #?SID=162525000_gidpeajj&FolderID=0&REF=1318197280
     #               https://email.o2online.de/smscenter_search.osp?SID=162525000_gidpeajj&FolderID=0&REF=1318198014
      #              https://email.o2online.de/smscenter_search.osp?SID=162525000_gidpeajj&FolderID=0&REF=1318198983"

    PER_PAGE     = 50

    attr_reader :user

    def initialize
      @browser = Mechanize.new do |agent|
        agent.user_agent_alias = 'Mac Safari'
        agent.follow_meta_refresh = true
      end
      @logged_in = false
    end

    def login(user, password)
      @user = user
      @browser.get(LOGIN_PAGE).tap do |page|
        page.forms.first.tap do |form|
          form.field_with(:name => "loginName:loginName").value = user
          form.field_with(:name => "password:password").value = password
          @browser.submit(form, form.buttons.first)
        end
      end
      if @logged_in = (@browser.page.uri.to_s == LOGIN_SUCCESS_PAGE)
        #force to set o3sisCookie by going to index
        @browser.get INDEX_PAGE
      end
    end

    def page
      @browser.page
    end

    def logged_in?
      @logged_in
    end

    #private
    def get_edit_page(id)
      @browser.get "#{EDIT_PAGE}#{id}"
    end

    def get_archive_page(page_nr = 1)
      @browser.get ARCHIVE_PAGE
    end

#parse_archive
    def parse_archive(archive)
      archive.parser.css("table.CONTENTLIST tr").map do |line|
        parse_archive_line line
      end.compact
    end

    def parse_archive_line(line)
      date, name, text, dummy = line.css("td.CONTENTTEXT")
      return unless date
      Websms::O2online::Sms.new( :received => false, :account => self, :raw_date => date, :raw_name => name, :raw_text => text )
    end

  end
end
