require 'rake'
require 'rubygems'
require 'rspec/core/rake_task'

task :default => [:spec, :test]

task :test do
  require File.dirname(__FILE__) + '/test/all_tests.rb'
end

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) 

desc "Run all specs with detailed reporting"
RSpec::Core::RakeTask.new(:spec_detailed) do |t|
  t.rspec_opts = ["--format", "documentation"]
end
