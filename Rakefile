require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "websms"
    gem.summary = %Q{The ruby way to deal with websms - send and access ur SMS easily. By now o2online and gMail are supported}
    gem.description = %Q{With this gem you easily have access and send SMS possibities to several online SMS services}
    gem.email = "tobi@rngtng.com"
    gem.homepage = "http://github.com/rngtng/websms-ruby"
    gem.authors = ["Tobias Bielohlawek"]
#    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

desc "Migrate Database"
task :migrate do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
  require "websms"

  Websms::Db::connect
  ActiveRecord::Migrator.up('db/migrate')
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "websms #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
