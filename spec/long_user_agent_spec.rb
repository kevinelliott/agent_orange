require File.dirname(__FILE__) + '/spec_helper'
require 'net/http'
require 'iconv'

describe AgentOrange::UserAgent do
  describe 'checking with real browsers list' do
    before  do
      @lists = [Iconv.new('UTF-8//IGNORE', 'UTF-8').iconv( File.open("spec/fixtures/browser_ids.htm").read)]

      begin
        @lists.push Net::HTTP.get('www.zytrax.com', '/tech/web/browser_ids.htm')
      rescue
      end
    end

    it "should parse browsers from list" do
      [
        {
          :a_name => 'chrome',
          :browser_names => ['Chrome', 'Safari']
        },
        {
          :a_name => 'safari',
          :browser_names => ['Safari']
        },
        {
          :a_name => 'firefox',
          :browser_names => ['Firefox']
        },
        {
          :a_name => 'msie',
          #chromeframe!
          :browser_names => ['MSIE', 'Chrome']
        },
        {
          :a_name => 'opera',
          :browser_names => ['Opera']
        }
      ].each do |params|
        part = ''

        @lists.each do |list|
          part += list.scan(/<a name="#{params[:a_name]}">.+?<a name="/m).first.to_s
        end

        part.scan(/<p class="g-c-s">([^<]+)<\/p>/).each do |q|
          unless params[:browser_names]== ['Opera'] && q.first == 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)'
            ua = AgentOrange::UserAgent.new(q.first)
            br_name = ua.device.engine.browser.name

            puts "Test failing at user id: '#{q}'" unless params[:browser_names].include?(br_name)
            params[:browser_names].should include(br_name)
          end
        end
      end
    end
  end
end