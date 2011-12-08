require File.dirname(__FILE__) + '/spec_helper'
require 'net/http'
require 'iconv'

describe AgentOrange::UserAgent do

  describe "Safari" do
    detect "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; de-at) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1" do |ua|
      ua.device.type.should == :computer
      ua.device.name.should == "Computer"
      ua.device.version.should == nil

      ua.device.operating_system.name.should == "Mac OS X"
      ua.device.operating_system.version.to_s.should == "10.6.8"

      ua.device.platform.name.should == "Macintosh"
      ua.device.platform.version.should == nil

      ua.device.engine.name.should == "AppleWebKit"
      ua.device.engine.version.to_s.should == "533.21.1"

      ua.device.engine.browser.name.should == "Safari"
      ua.device.engine.browser.version.to_s.should == "533.21.1"
    end

    detect "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_1) AppleWebKit/535.5 (KHTML, like Gecko) Chrome/16.0.891.1 Safari/535.5" do |ua|
      ua.device.type.should == :computer
      ua.device.name.should == "Computer"
      ua.device.version.should == nil

      ua.device.operating_system.name.should == "Mac OS X"
      ua.device.operating_system.version.to_s.should == "10.7.1"

      ua.device.platform.name.should == "Macintosh"
      ua.device.platform.version.should == nil

      ua.device.engine.name.should == "AppleWebKit"
      ua.device.engine.version.to_s.should == "535.5"

      ua.device.engine.browser.name.should == "Safari"
      ua.device.engine.browser.version.to_s.should == "535.5"
    end
  end

  describe "Firefox" do
    detect "Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20100101 Firefox/6.0" do |ua|
      ua.device.type.should == :computer
      ua.device.name.should == "Computer"
      ua.device.version.should == nil

      ua.device.operating_system.name.should == "Linux"
      ua.device.operating_system.version.to_s.should == "i686"

      ua.device.platform.name.should == "PC"
      ua.device.platform.version.should == nil

      ua.device.engine.name.should == "Gecko"
      ua.device.engine.version.to_s.should == "20100101"

      # TODO should be Chrome.
      ua.device.engine.browser.name.should == "Firefox"
      ua.device.engine.browser.version.to_s.should == "6.0"
    end
  end

  describe "Chrome" do
    detect "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.872.0 Safari/535.2" do |ua|
      ua.device.type.should == :computer
      ua.device.name.should == "Computer"
      ua.device.version.should == nil

      ua.device.operating_system.name.should == "Windows"
      ua.device.operating_system.version.to_s.should == "5.1"

      ua.device.platform.name.should == "PC"
      ua.device.platform.version.should == nil

      ua.device.engine.name.should == "AppleWebKit"
      ua.device.engine.version.to_s.should == "535.2"

      # TODO should be Chrome.
      ua.device.engine.browser.name.should == "Safari"
      ua.device.engine.browser.version.to_s.should == "535.2"
    end
  end

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
          :browser_names => ['Safari']
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
          :browser_names => ['MSIE','IEMobile']
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
          ua = AgentOrange::UserAgent.new(q.first)
          br_name = ua.device.engine.browser.name

          params[:browser_names].should include(br_name)
        end
      end
    end

  end


end