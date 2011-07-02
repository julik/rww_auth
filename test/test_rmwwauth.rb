require "bundler"
Bundler.require(:test)

require File.expand_path(File.dirname(__FILE__)) + "/../lib/rmww_auth"
require 'test/unit'

VCR.config do |c|
  c.cassette_library_dir = File.expand_path(File.dirname(__FILE__)) + "/cassettes"
  c.stub_with :webmock
end

class TestRWWAuth < Test::Unit::TestCase
  def test_passing_auth_over_ssl
    VCR.use_cassette('passing_auth_with_SSL') do
      a = RemoteWorkplaceAuth.new("mail.enterprise.co.uk", true)
      assert_equal true, a.auth("julik", "secret")
    end
  end
  
  def test_failing_auth_over_ssl
    VCR.use_cassette('failing_auth_with_SSL') do
      a = RemoteWorkplaceAuth.new("mail.enterprise.co.uk", true)
      assert_equal false, a.auth("julik", "fake")
    end
  end
  
end