module Websms
  class O2online

    LOGIN_PAGE   = "https://login.o2online.de/loginRegistration/loginAction.do?_flowId=login&o2_type=asp&o2_label=login/comcenter-login&scheme=http&port=80&server=email.o2online.de&url=%2Fssomanager.osp%3FAPIID%3DAUTH-WEBSSO"
    ARCHIVE_PAGE = "https://email.o2online.de/smscenter_search.osp?SID=124092227_otzulfav&FolderID=0&REF=1283731906&EStart="
    EDIT_PAGE    = "https://email.o2online.de/smscenter_new.osp?Autocompletion=1&SID=124683602_emgucyuj&REF=1284069078&MsgContentID="

    PER_PAGE     = 50

    attr_reader :user

    def initialize
      @browser = Mechanize.new do |agent|
        agent.follow_meta_refresh = true
      end
      @logged_in = false
    end

    def login(user, password)
      @user = user
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
      Websms::O2online::Sms.new( :account => self, :receiver_tel => self.user, :raw_date => date, :raw_sender => sender, :raw_text => text )
    end

    ##############################################################################################################

    class Sms < Websms::Sms

      def initialize(data = {})
        @account = data.delete(:account)
        data.each { |key,value| send("#{key}=", value) }
      end

      # def id
      #   @id ||= @raw_text.css("a").first.attributes["onclick"].value.scan(/'([^']+)'/u)[0][0]
      # end

      def sender_name
        @sender_name ||= sender.first
      end

      def sender_tel
        @sender_tel ||= sender.last
      end

      def raw_date=(raw_date)
        #date = date.content.split("\n")[3].strip
        day, month, year, hour, minute = raw_date.content.scan(/\('([^)]*)'\)/).first.first.split("', '")
        @date = "#{day}.#{month}.#{year} #{hour}:#{minute}"
      end

      def raw_sender=(raw_sender)
        data = raw_sender.content
        reg = (data =~ /&gt/) ? /'(.+) &lt;(.*)&gt;,'/ : /'()(.+)'/
        @sender = data.scan(reg)[0]
      end

      def raw_text=(raw_text)
        @text = raw_text.content.scan(/cleanMessage\('(.*)'\),/)[0][0]
        @text = long_text if @text.size > 90
        @text
      end

      private
      def sender
        @sender || []
      end

      def long_text
        return @text unless @account
        raw_text = @account.get_edit_page(id)
        raw_text.parser.css("textarea.LARGE").first.content
      end
    end

  end
end
