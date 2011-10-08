# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "websms"
  s.version     = File.read("VERSION").to_s
  s.authors     = ["Tobias Bielohlawek"]
  s.email       = ["tobi@rngtng.com"]
  s.homepage    = "http://github.com/rngtng/websms-ruby"
  s.summary     = %q{The ruby way to deal with websms - send and access ur SMS easily. By now o2online and gMail are supported}
  s.description = %q{With this gem you easily have access and send SMS possibities to several online SMS services}

  s.rubyforge_project = "websms-ruby"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  ['activerecord', 'mechanize'].each do |gem| #, 'activesupport ~>2.3.8'
    s.add_dependency *gem.split(' ')
  end

  ['rspec'].each do |gem|
    s.add_development_dependency *gem.split(' ')
  end
end
