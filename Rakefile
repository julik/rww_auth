# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/rmww_auth'

Hoe::RUBY_FLAGS.gsub!(/^\-w/, '') # No thanks undefined ivar warnings
Hoe.spec 'rww_auth' do | s |
  s.version = RemoteWorkplaceAuth::VERSION
  s.readme_file   = 'README.rdoc'
  s.developer('Julik', 'me@julik.nl')
  s.extra_dev_deps = {"vcr" => "~> 1.0.0"}
  s.clean_globs = %w( **/.DS_Store  coverage.info **/*.rbc .idea .yardoc)
end

# vim: syntax=ruby
