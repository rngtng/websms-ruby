require 'mechanize'

require 'sms'

class O2online

  LOGIN_PAGE  = "https://login.o2online.de/loginRegistration/loginAction.do?_flowId=login&o2_type=asp&o2_label=login/comcenter-login&scheme=http&port=80&server=email.o2online.de&url=%2Fssomanager.osp%3FAPIID%3DAUTH-WEBSSO"
  SENT_PAGE   = "https://email.o2online.de/smscenter_search.osp?SID=124092227_otzulfav&FolderID=0&REF=1283731906&EStart="
  EDIT_PAGE   = "https://email.o2online.de/ssomanager.osp?APIID=AUTH-WEBSSO&TargetApp=/smscenter_new.osp%3FAutocompletion%3D1%26SID%3D124234135_athoonis%26REF%3D1283811721%26MsgContentID%3D"


  def initialize
    @browser = Mechanize.new { |agent|
      agent.follow_meta_refresh = true
    }

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

  def logged_in?
    @logged_in
  end

  def get_page( page_nr = 1 )
    parse_page @browser.get "#{SENT_PAGE}#{page_nr*50}"
  end

  #private
  def parse_page( page )
    page.css("table.CONTENTLIST tr").map do |line|
      parse_line line
    end.compact
  end

  def parse_line( line )
    date, sender, text, dummy = line.css("td.CONTENTTEXT")
    text ? SMS.new(date, sender, text) : nil
  end

end


# def html(url)
#   @browser.goto(url)
#   Nokogiri::HTML(Iconv.conv('ISO-8859-1', 'utf-8', @browser.html))
# end
