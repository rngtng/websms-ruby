require 'mechanize'

module Websms
  class O2online
    PER_PAGE   = 50
    LOGIN_PAGE = "https://login.o2online.de/loginRegistration/loginAction.do" +
      "?_flowId=login&o2_type=asp&o2_label=login/" +
      "comcenter-login&scheme=http&port=80&server=email" +
      ".o2online.de&url=%2Fssomanager.osp%3FAPIID%3D" +
      "AUTH-WEBSSO%26TargetApp%3D%2Fsmscenter_new.osp" +
      "%253f%26o2_type%3Durl%26o2_label%3Dweb2sms-o2online"

    SUCCESS_PAGE = "https://email.o2online.de/ssomanager.osp?APIID=AUTH-WEBSSO&TargetApp=/smscenter_new.osp%3f&o2_type=url&o2_label=web2sms-o2online&loginsuccess=true"
    INDEX_PAGE   = "https://email.o2online.de/ssomanager.osp?APIID=AUTH-WEBSSO"
    ARCHIVE_PAGE = "https://email.o2online.de/smscenter_search.osp?EStart=%s"
    EDIT_PAGE    = "https://email.o2online.de/smscenter_new.osp?Autocompletion=1&SID=124683602_emgucyuj&REF=1284069078&MsgContentID=%s"

    PATTERN = %q{
       getDueDate\('(?<day>\d+)',.'(?<month>\d+)',.'(?<year>\d+)',.'(?<hour>\d+)',.'(?<minute>\d+)'.+
       cleanRecipient\('((?<rname>.+?).&lt;)?(?<rtel>[+\d]+).+
       cleanMessage\('(?<text>.+?)'\).+
       displaySendStatus\((?<status>\d+),'(?<id>\d+)'
     }

    def initialize
      @browser = Mechanize.new do |agent|
        agent.user_agent_alias = 'Mac Safari'
        agent.follow_meta_refresh = true
      end
    end

    def login(user, password)
      @browser.get(LOGIN_PAGE).tap do |page|
        page.forms.first.tap do |form|
          form.field_with(:name => "loginName:loginName").value = user
          form.field_with(:name => "password:password").value = password
          @browser.submit(form, form.buttons.first)
        end
      end
      if @logged_in = (@browser.page.uri.to_s == SUCCESS_PAGE)
        #force to set o3sisCookie by going to index
        @browser.get INDEX_PAGE
      end
    end

    def logged_in?
      @logged_in
    end

    def archive_page(page_nr = 1)
      @browser.get(ARCHIVE_PAGE % ((page_nr - 1) * PER_PAGE)).root.css(".NOLINK").map do |line|
        line.attr('onclick').match(/'(\d+)'/)[1]
      end
    end

    private
    def get_edit_page(id)
      @browser.get "#{EDIT_PAGE}#{id}"
    end

    # def parse_archive(page)
    #   page.root.css(".NOLINK").map do |line|
    #     line.attr('onclick').scan(/'(\d+)'/)
    #   end
    # end

  end
end


