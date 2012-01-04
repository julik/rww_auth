# -*- ruby -*-
require "bundler"
Bundler.require(:development)
require './lib/rww_auth'

Jeweler::Tasks.new do |gem|
  gem.version = RemoteWorkplaceAuth::VERSION
  gem.name = "rww_auth"
  gem.summary = "Authenticate against an Outlook Webmail install. Seriously, f#ck LDAP."
  gem.email = "me@julik.nl"
  gem.homepage = "http://github.com/julik/rww_auth"
  gem.authors = ["Julik Tarkhanov"]
end

Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
desc "Run all tests"
Rake::TestTask.new("test") do |t|
  t.libs << "test"
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end
task :default => :test

# vim: syntax=ruby
