require "lib/agent_orange"
require 'rexml/document'

task :test_bots do
	success = 0
	fail = 0
	# tests for successful bot detection
	user_agent_strings = [
		"ia_archiver (+http://www.alexa.com/site/help/webmasters; crawler@alexa.com)",
		"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
		]

	puts
	puts "parsing the user-agents.org list..."
	doc = REXML::Document.new(File.open("lib/tasks/allagents.xml"))
	doc.elements.each("user-agents/user-agent") do |ua|
		go = false
		ua.elements.each("Type") do |item|
			if item.text == "R" || item.text == "S"
				go = true
			end
		end
		if go
			ua.elements.each("String") do |item|
				user_agent_strings << item.text
			end
		end
	end
	puts "testing..."
	user_agent_strings.each do |ua_str|
		ua = AgentOrange::UserAgent.new(ua_str)
		if ua.is_bot?
			#puts "SUCCESS:: " + ua_str
			success += 1
		else
			#puts "FAIL:: " + ua_str
			fail += 1
		end
	end

	puts success.to_s + " succeed. BENCHMARK: 376"
	puts fail.to_s + " fail. BENCHMARK: 1083"

end
