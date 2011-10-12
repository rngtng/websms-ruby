require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'vcr'
require 'websms'

VCR.config do |c|
   c.cassette_library_dir = './'
   c.stub_with :fakeweb
end

task :anonym do
  f = 'spec/fixtures/vcr_cassettes/o2online/first_archive_page'
  content = File.open(f + ".yml", "r").read

  class String
    def self.random(length=20)
      chars = ('a'..'z').to_a + ('A'..'Z').to_a + ("0".."9").to_a
      hash = ""; length.times { hash << chars[rand(chars.size)] }; hash
    end
  end

  VCR.use_cassette(f) do
    browser = Websms::O2online.new
    browser.login("asd", "asd")
    data = browser.parse_archive(browser.get_archive_page)
    data.each do |line|
      if match = line.match(/#{Websms::O2online::PATTERN}/mix)
        if match["rname"]
          m = Iconv.conv('ISO-8859-1', 'utf-8', match["rname"])
          content.gsub!(m, String.random(match["rname"].size))
        end
        if match["rtel"]
          content.gsub!(match["rtel"], "+#{"0" * (match["rtel"].size-1)}")
        end
        if match["text"]
          m = Iconv.conv('ISO-8859-1', 'utf-8', match["text"])
          content.gsub!(match["text"], String.random(match["text"].size))
        end
      end
    end
  end

  file = File.open(f + "NEW.yml", "w") do |f|
    f.puts content
  end

end