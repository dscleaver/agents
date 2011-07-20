# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "agents"
  gem.homepage = "http://github.com/dscleaver/agents"
  gem.license = "MIT"
  gem.summary = %Q{TODO: one-line summary of your gem}
  gem.description = %Q{TODO: longer description of your gem}
  gem.email = "dscleaver@gmail.com"
  gem.authors = ["dscleaver"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core/rake_task'

task :default => [:spec, :test]

task :test do
  require File.dirname(__FILE__) + '/test/all_tests.rb'
end

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--color"]
end
 
desc "Run all specs with detailed reporting"
RSpec::Core::RakeTask.new(:spec_detailed) do |t|
  t.rspec_opts = ["--format", "documentation", "--color"]
end
