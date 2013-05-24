require 'spec_helper'

describe AgentOrange::UserAgent, "bot detection" do
  bot_uas = [
    'AdsBot-Google (+http://www.google.com/adsbot.html)',
    'AdsBot-Google-Mobile (+http://www.google.com/mobile/adsbot.html) Mozilla (iPhone; U; CPU iPhone OS 3 0 like Mac OS X) AppleWebKit (KHTML, like Gecko) Mobile Safari',
    'Mozilla/5.0 (compatible; firmilybot/0.1; +http://www.firmily.com/bot.php',
    'ClickTale bot',
    'googlebot',
    'Googlebot/2.1 (http://www.googlebot.com/bot.html)',
    'googlebot/bot.htm',
    'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_1 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8B117 Safari/6531.22.7 (compatible; Googlebot-Mobile/2.1; +http://www.google.com/bot.html)',
    'Googlebot',
    'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)',
    'SAMSUNG-SGH-E250/1.0 Profile/MIDP-2.0 Configuration/CLDC-1.1 UP.Browser/6.2.3.3.c.1.101 (GUI) MMP/2.0 (compatible; Googlebot-Mobile/2.1; +http://www.google.com/bot.html)',
    'Googlebot/2.1 (+http://www.google.com/bot.html)',
    'DoCoMo/2.0 N905i(c100;TB;W24H16) (compatible; Googlebot-Mobile/2.1; +http://www.google.com/bot.html)',
    'Googlebot-richsnippets',
    'Googlebot/2.1; +http://www.google.com/bot.html)',
    'Who.is Bot',
    'Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.8.0.11)  Firefox/1.5.0.11; 360Spider',
    'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; MDDR; .NET4.0C; .NET4.0E; .NET CLR 1.1.4322; Tablet PC 2.0); 360Spider',
  ]

  bot_uas.each do |uastring|
    it "#{uastring} should be detected as bot" do
      ua = AgentOrange::UserAgent.new(uastring)

      ua.device.bot.should == true
    end
  end
end