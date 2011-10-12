require 'spec_helper'

SMS_PATH = 'spec/fixtures/sms'
CFG_FILE = File.expand_path('spec/fixtures/files.yml')
config = YAML::load(File.open(CFG_FILE))


def get_test_size(file_name, test_pattern)
  `grep -E '#{test_pattern}' #{file_name} | wc -l`.strip.to_i
end


describe "File" do
  let(:raw_smss) { File.open(file_path).read.scan(/(?<main>#{pattern})/ix) }
  let(:sms) do
    raw_smss.map do |raw_sms|
      Websms::Sms.new.tap do |new_sms|
        new_sms.fill(raw_sms.first, pattern)
      end
    end
  end

  config.each do |file_name, cfg|

    context file_name do
      let(:file_path) { File.join(SMS_PATH, file_name) }
      let(:test_size) { get_test_size(file_path, cfg['test']) }
      let(:pattern) { cfg['pattern'] }

      it "has correct size" do
        sms.size.should == test_size
      end

      it "show attr" do
        puts "#{file_name} -> " + sms.last.attributes['text'][0..40]
      end
    end
  end

end
