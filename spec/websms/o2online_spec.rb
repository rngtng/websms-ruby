require 'spec_helper'
require 'websms/o2online'

describe Websms::O2online do
  subject(:client) { Websms::O2online.new }

  let(:user) { ENV['nr'] }
  let(:password) { ENV['pwd'] }

  before do
    client.login(user, password)
  end

  describe 'login', :vcr => { :cassette_name => "websms/o2online/login/ok" } do
    its(:logged_in?) { should be_true }

    context "wrong password", :vcr => { :cassette_name => "websms/o2online/login/fail" } do
      let(:password) { 'sowrong' }

      its(:logged_in?) { should be_false }
    end
  end

  describe 'all_sms', :vcr => { :cassette_name => "websms/o2online/all_sms" } do
    subject { client.all_sms(false) }

    its(:size) { should == 0 }
  end

  ############################################################################################

  describe 'archive_page', :vcr => { :cassette_name => "websms/o2online/archive_page" } do
    let(:resolve) { false }
    subject(:all) { client.send(:archive_page, 1, resolve) }

    context "looking at the ids" do
      subject { all.map { |sms| sms[:id] } }

      it do
        should == ["20213085", "20212947", "20191132", "20190776", "20189889", "20184093", "20139336", "20137758", "20137705", "20134495", "20134207", "20132342", "20132328", "20128970", "20128297", "20127870", "20127861", "20127339", "20127037", "20126284", "20126099", "20125835", "20123351", "20123285", "20111663", "20111007", "20110444", "20109808", "20107792", "20102019", "20101430", "20101046", "20099787", "20084908", "20084733", "20084728", "20080927", "20079870", "20079551", "20078821", "20078775", "20074296", "20072144", "20069775", "20069208", "20067061", "20067042", "20066011", "20065762", "20065585"]
      end
    end

    context "looking at the last sms" do
      subject { all.last }

      it do
        should == {
          :date => "16.8.2013 15:34",
          :id   => "20065585",
          :rtel => "00491774900021",
          :text => "Ach gerne aber komm wie's auschaut erst 20:30 an und muss dann noch mein zeusch ablegen.. Ich ruf sp"
        }
      end

      context 'when resolving enabled', :vcr => { :cassette_name => "websms/o2online/archive_page_resolve" }  do
        let(:resolve) { true }

        it "gets data from first sms" do
          should == {
            :date => "16.8.2013 15:34",
            :id   => "20065585",
            :rtel => "00491774900021",
            :text => "Ach gerne aber komm wie's auschaut erst 20:30 an und muss dann noch mein zeusch ablegen.. Ich ruf sp"
          }
        end
      end
    end
  end

  describe 'edit_page', :vcr => { :cassette_name => "websms/o2online/edit_page" } do
    subject { client.send(:edit_page, "20065585") }

    it "extracs sms ids" do
      should == {
        :date => "16.8.2013 15:34",
        :id   => "20065585",
        :rtel => "00491774900021",
        :text => "Ach gerne aber komm wie's auschaut erst 20:30 an und muss dann noch mein zeusch ablegen.. Ich ruf sp"
      }
    end
  end

end
