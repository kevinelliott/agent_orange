require File.dirname(__FILE__) + '/spec_helper'
require 'net/http'
require 'iconv'

describe AgentOrange::UserAgent do

  describe "Safari" do
    detect "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; de-at) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1" do |ua|
      ua.device.type.should == :computer
      ua.device.name.should == "Computer"
      ua.device.version.should == nil
      ua.device.bot.should == false

      ua.device.operating_system.name.should == "Mac OS X"
      ua.device.operating_system.version.to_s.should == "10.6.8"

      ua.device.platform.name.should == "Macintosh"
      ua.device.platform.version.should == nil

      ua.device.engine.name.should == "AppleWebKit"
      ua.device.engine.version.to_s.should == "533.21.1"

      ua.device.engine.browser.name.should == "Safari"
      ua.device.engine.browser.version.to_s.should == "533.21.1"
    end
  end

  describe "Firefox" do
    detect "Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20100101 Firefox/6.0" do |ua|
      ua.device.type.should == :computer
      ua.device.name.should == "Computer"
      ua.device.version.should == nil
      ua.device.bot.should == false

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
      ua.device.bot.should == false

      ua.device.operating_system.name.should == "Windows"
      ua.device.operating_system.version.to_s.should == "5.1"

      ua.device.platform.name.should == "PC"
      ua.device.platform.version.should == nil

      ua.device.engine.name.should == "AppleWebKit"
      ua.device.engine.version.to_s.should == "535.2"

      ua.device.engine.browser.name.should == "Chrome"
      ua.device.engine.browser.version.to_s.should == "15.0.872.0"
    end

    detect "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_1) AppleWebKit/535.5 (KHTML, like Gecko) Chrome/16.0.891.1 Safari/535.5" do |ua|
      ua.device.type.should == :computer
      ua.device.name.should == "Computer"
      ua.device.version.should == nil
      ua.device.bot.should == false

      ua.device.operating_system.name.should == "Mac OS X"
      ua.device.operating_system.version.to_s.should == "10.7.1"

      ua.device.platform.name.should == "Macintosh"
      ua.device.platform.version.should == nil

      ua.device.engine.name.should == "AppleWebKit"
      ua.device.engine.version.to_s.should == "535.5"

      ua.device.engine.browser.name.should == "Chrome"
      ua.device.engine.browser.version.to_s.should == "16.0.891.1"
    end

    detect "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; chromeframe/13.0.782.218; chromeframe; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)" do |ua|
      ua.device.type.should == :computer
      ua.device.name.should == "Computer"
      ua.device.version.should == nil
      ua.device.bot.should == false

      ua.device.engine.browser.name.should == "Chrome"
      ua.device.engine.browser.version.to_s.should == "13.0.782.218"
    end
  end
  
  describe "Google User Agents" do
    detect "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_1 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8B117 Safari/6531.22.7 (compatible; Googlebot-Mobile/2.1; +http://www.google.com/bot.html)" do |ua|
      ua.device.type.should == :mobile
      ua.device.name.should == "Mobile"
      ua.device.version.should == nil
      ua.device.bot.should == true
      ua.is_mobile?.should == true
      ua.is_computer?.should == false
      ua.is_bot?.should == true

      ua.device.engine.browser.name.should == "Safari"
      ua.device.engine.browser.version.to_s.should == "6531.22.7"    
    end
    
    detect "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" do |ua|
      ua.device.type.should == :bot
      ua.device.name.should == "Bot"
      ua.device.version.should == nil
      ua.device.bot.should == true
      ua.is_mobile?.should == false
      ua.is_computer?.should == false
      ua.is_bot?.should == true

      ua.device.engine.browser.name.should == nil
      ua.device.engine.browser.version.to_s.should == ""
    end
    
  end
end