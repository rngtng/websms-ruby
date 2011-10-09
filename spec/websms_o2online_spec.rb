require 'spec_helper'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes/o2online'
  # c.default_cassette_options = { :record => :once }
  c.stub_with :fakeweb
end

FIXTURE_PATH = "spec/fixtures/"

describe Websms::O2online do
  let(:browser) { Websms::O2online.new }

  context "parse_archive_line" do
    let(:line) { Nokogiri::HTML File.read(FIXTURE_PATH  + file_name) }

    context "line with tel" do
      let(:filename) { "line_tel.html" }
      subject  { browser.send :parse_archive_line, line }

      it "parses date" do
        date.should == "7.9.2010 18:03"
      end

      it "parses sender name" do
        sender_name.should == ""
      end

      it "parses tel" do
        sender_tel.should == "+4915222222222"
      end

      it "parses text" do
        text.should == "Heb dir mal Hunger auf, muss spter unbedingt was leckres essen ;-)"
      end
    end

    context "line with tel and anme " do
      let(:filename) { "line_name_tel.html" }
      subject  { browser.send :parse_archive_line, line }

      it "parses sender name" do
        sender_name.should == "Johanna"
      end

      #TODO shared test here??
    end
  end
end
