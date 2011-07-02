require 'rubygems'
require 'net/http'
require 'net/https'

=begin
ActiveDirectory-Exchange-Blaggh authentication guerilla-style. Will take the give username and password and try to authenticate
them against the give Remote Web Workplace server. This assumes that the user on a domain also has an email address
with OWA of course. If the user is found RWW will give us a specific response. No credentials or user information is
retrieved. Please go and make OpenID frontends from that, I dare you!

Usage:

    rww_servr = RemoteWebWorkplaceAuth.new("intranet.bigenterprise.com" use_ssl = true)
    if rww_servr.authenticate("julik", "topsecret")
      puts "Yuppie!"
    else
      puts "No donut"
    end

=end

class RemoteWorkplaceAuth
  VERSION = "1.0.0"
  VIEW_STATE_PAT =  /name="__VIEWSTATE" value="([^"]+)"/
  
  attr_accessor :server, :use_ssl
  
  def initialize(hostname, use_ssl = true)
    @server = hostname
    @base_login_url = '/Remote/logon.aspx?ReturnUrl=%2fRemote%2fDefault.aspx'
    @outlook = if use_ssl
      o = Net::HTTP.new(@server, 443)
      o.use_ssl = true
      o.verify_mode = OpenSSL::SSL::VERIFY_NONE
      o
    else
      Net::HTTP.new(@server)
    end
  end
  
  # Will run the auth
  def auth(user, password)
    with_viewstate do | payload |
      login_form_values  = {
        "txtUserName" => user.to_s,
        "txtUserPass" => password.to_s,
        "cmdLogin" => "cmdLogin",
        "listSpeed" => "Broadband",
        "__VIEWSTATE" => payload,
      }
      
      begin
        @outlook.start do |http|
          form_post = Net::HTTP::Post.new("/Remote/logon.aspx")
          form_post.set_form_data(login_form_values, '&')
          response = http.request(form_post); response.value
        end
      rescue Net::HTTPRetriableError => e
        if e.message =~ /302/ # RWW will return a redirect if the user is found
          return true
        end
      end
      
      return false
    end
  end
  
  private
    def with_viewstate
      viewstate_payload = @outlook.start do |http|
        request = Net::HTTP::Get.new(@base_login_url)
        response = http.request(request); response.value
        response.body.scan(VIEW_STATE_PAT).pop.pop
      end
      yield viewstate_payload
    end
end

if __FILE__ == $0
  p "Your server: "
  p(server = gets.chomp)
  
  p "Use HTTPS? [y/n]: " 
  p(use_ssl = !!(gets =~ /y/i))
  p "Username: " 
  p(login = gets.chomp)
  p "Password: " 
  pass = gets.chomp
  
  a = RemoteWorkplaceAuth.new(server, use_ssl)
  if a.auth(login, pass)
    puts "========================"
    puts "Auth passed, user exists"
  else
    puts "==========="
    puts "Auth failed"
  end
end