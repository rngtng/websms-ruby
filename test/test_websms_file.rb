require 'helper'

class TestWebsmsFile < Test::Unit::TestCase

  def test_should_eval_key_correctly
    sms = Websms::File::Sms.new
    assert_equal 'b', sms.send(:eval_key, "$1", ['a', 'b'])
  end

  def test_should_eval_key_correctly_when_not_exists
    sms = Websms::File::Sms.new
    assert_equal 'b a', sms.send(:eval_key, "$1 $0 $2", ['a', 'b'])
  end
end
