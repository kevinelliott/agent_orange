require "agent_orange"
require 'rexml/document'

desc "Test bots detection"
task :test_bots do
	success = 0
	fail = 0
	
	# tests for successful bot detection
	bot_user_agent_strings = [
		"ia_archiver (+http://www.alexa.com/site/help/webmasters; crawler@alexa.com)",
		"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
		]
	browser_user_agent_strings = [
		"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_5; sv-se) AppleWebKit/525.26.2 (KHTML, like Gecko) Version/3.2 Safari/525.26.12",
	  "Mozilla/5.0 (iPhone; U; Linux i686; pt-br) AppleWebKit/532+ (KHTML, like Gecko) Version/3.0 Mobile/1A538b Safari/419.3 Midori/0.2.0",
	  "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_1 like Mac OS X; zh-tw) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8G4 Safari/6533.18.5",
	  "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; de-at) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1",
	  "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_8; en-us) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1",
	  "Mozilla/5.0 (Windows; U; Windows NT 6.1; tr-TR) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27",
	  "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)",
	  "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; Zune 4.0; InfoPath.3; MS-RTC LM 8; .NET4.0C; .NET4.0E)",
	  "Mozilla/5.0 (Windows NT 6.1; rv:6.0) Gecko/20110814 Firefox/6.0",
	  "Mozilla/5.0 (X11; U; Linux i586; de; rv:5.0) Gecko/20100101 Firefox/5.0",
	  "Opera/9.80 (Windows NT 6.1; U; es-ES) Presto/2.9.181 Version/12.00",
	  "Opera/9.80 (X11; Linux i686; U; ru) Presto/2.8.131 Version/11.11"
		]
	puts
	puts "parsing the user-agents.org list..."
	doc = REXML::Document.new(File.open("lib/tasks/allagents.xml"))
	doc.elements.each("user-agents/user-agent") do |ua|
		bot = false
		browser = false
		ua.elements.each("Type") do |item|
			if item.text == "R" || item.text == "S"
				bot = true
			elsif item.text == "B"
				browser = true
			end
			
		end
		if bot
			ua.elements.each("String") do |item|
				bot_user_agent_strings << item.text
			end
		end
		if browser
                        ua.elements.each("String") do |item|
                                browser_user_agent_strings << item.text
                        end
                end
	end
	puts "testing..."
	bot_user_agent_strings.each do |ua_str|
		ua = AgentOrange::UserAgent.new(ua_str)
		if ua.is_bot?
			#puts "SUCCESS:: " + ua_str
			success += 1
		else
			#puts "FAIL:: " + ua_str
			fail += 1
		end
	end

	puts "BOT DETECTION"
	puts success.to_s + " succeed. BENCHMARK: 376"
	puts fail.to_s + " fail. BENCHMARK: 1083"
	
	success = 0
	fail = 0 

        browser_user_agent_strings.each do |ua_str|
                ua = AgentOrange::UserAgent.new(ua_str)
                if !ua.is_bot?
                        #puts "SUCCESS:: " + ua_str
                        success += 1
                else
                        #puts "FAIL:: " + ua_str
                        fail += 1
                end
        end

	puts "FALSE POSITIVES CHECK"
	puts success.to_s + " succeed. BENCHMARK: 326"
	puts fail.to_s + " fail. BENCHMARK: 4"

end
