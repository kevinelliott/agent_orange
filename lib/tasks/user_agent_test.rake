require "agent_orange"
require 'net/http'

desc "Test user browsers detection"
task :test_users do
  puts
  puts "parsing the browsers list..."

  html_list = Net::HTTP.get('www.zytrax.com', '/tech/web/browser_ids.htm')

  [
    {
      :a_name => 'chrome',
      :browser_name => 'Chrome'
    },
    {
      :a_name => 'safari',
      :browser_name => 'Safari'
    },
    {
      :a_name => 'firefox',
      :browser_name => 'Firefox'
    },
    {
      :a_name => 'msie',
      :browser_name => 'MSIE',
      :browser_name_second => 'IEMobile'
    },
    {
      :a_name => 'opera',
      :browser_name => 'Opera'
    }
  ].each do |params|
    part = html_list.scan(/<a name="#{params[:a_name]}">.+?<a name="/m).first.to_s

    part.scan(/<p class="g-c-s">([^<]+)<\/p>/).each do |q|
      ua = AgentOrange::UserAgent.new(q.first)
      br_name = ua.device.engine.browser.name

      unless (br_name == params[:browser_name]) || (params.has_key?(:browser_name_second) && (br_name == params[:browser_name_second]))
        puts
        puts "User agent string: '#{q}'"
        puts "Browser name by agent orange: '#{ua.device.engine.browser.name}'" 
        puts "Browser name should be: '#{params[:browser_name]}'"
      end
    end
  end;false

end
