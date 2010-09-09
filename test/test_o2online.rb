require 'helper'

class TestO2online < Test::Unit::TestCase

  def test_should_parse_line_with_tel
    line = Nokogiri::HTML File.read("./test/fixtures/line_tel.html")

    browser = O2online.new
    sms = browser.send :parse_archive_line, line
    
    assert_equal "7.9.2010 18:03", sms.date
    assert_equal "", sms.sender_name
    assert_equal "+4915222222222", sms.sender_tel
    assert_equal "Heb dir mal Hunger auf, muss spter unbedingt was leckres essen ;-)", sms.text
  end
  
  def test_should_parse_line_with_name_and_tel
    line = Nokogiri::HTML File.read("./test/fixtures/line_name_tel.html")

    browser = O2online.new
    sms = browser.send :parse_archive_line, line
    
    assert_equal "7.9.2010 18:03", sms.date
    assert_equal "Johanna", sms.sender_name
    assert_equal "+4915222222222", sms.sender_tel
    assert_equal "Heb dir mal Hunger auf, muss spter unbedingt was leckres essen ;-)", sms.text
  end  
end
