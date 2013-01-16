require 'agent_orange/base'
require 'agent_orange/version'

module AgentOrange
  class Browser < Base
    # @return [Symbol] one of the keys from {BROWSERS}
    attr_accessor :type

    # @return [String] one of the values from {BROWSERS}
    attr_accessor :name

    # @return [AgentOrange::Version]
    attr_accessor :version

    attr_accessor :security

    BROWSERS = {
      :ie       => 'MSIE|Internet Explorer|IE',
      :firefox  => 'Firefox',
      :opera    => 'Opera',
      :chrome   => 'Chrome',
      :safari   => 'Safari'
    }

    BROWSER_TITLES = BROWSERS.merge :ie => 'MSIE'

    def parse(user_agent)
      AgentOrange.debug "BROWSER PARSING", 2

      groups = parse_user_agent_string_into_groups(user_agent)
      groups.each_with_index do |content,i|
        if content[:name] =~ /(#{BROWSERS.collect{|cat,regex| regex}.join(')|(')})/i
          # Matched group against name
          self.populate(content)
          break
        elsif content[:comment] =~ /(#{BROWSERS.collect{|cat,regex| regex}.join(')|(')})/i
          # Matched group against comment
          chosen_content = { :name => nil, :version => nil }
          additional_groups = parse_comment(content[:comment])
          additional_groups.each do |additional_content|
            if additional_content[:name] =~ /(#{BROWSERS.collect{|cat,regex| regex}.join(')|(')})/i
              chosen_content = additional_content

              #Additional checking for chromeframe, iemobile, etc.
              BROWSERS.each do |cat, regex|
                chosen_content[:name] = BROWSER_TITLES[cat] if additional_content[:name] =~ /(#{regex})/i
              end
            end
          end

          populate(chosen_content)
        end
      end

      analysis
    end

    # @return [Browser]
    def populate(content={})
      debug_raw_content(content)
      AgentOrange.debug "", 2

      self.type = determine_type(BROWSERS, content[:name])
      self.name = content[:name]
      self.version = AgentOrange::Version.new(content[:version])
      self
    end

    # @return {String}
    def to_s
      [name, version].compact.join(' ')
    end
  end
end
