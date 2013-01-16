require 'agent_orange/base'
require 'agent_orange/browser'
require 'agent_orange/version'

module AgentOrange
  class Engine < Base
    # @return [Symbol] one of the keys from {ENGINES}
    attr_accessor :type

    # @return [String] one of the values from {ENGINES}
    attr_accessor :name

    # @return [AgentOrange::Version]
    attr_accessor :version

    # @return [AgentOrange::Browser]
    attr_accessor :browser

    ENGINES = {
      :gecko  => 'Gecko',
      :presto => 'Presto',
      :trident => 'Trident',
      :webkit => 'AppleWebKit',
      :other => 'Other'
    }

    def parse(user_agent)
      AgentOrange.debug "ENGINE PARSING", 2

      groups = parse_user_agent_string_into_groups(user_agent)
      groups.each_with_index do |content,i|
        if content[:name] =~ /(#{ENGINES.collect{|cat,regex| regex}.join(')|(')})/i
          # Matched group against name
          populate(content)
        elsif content[:comment] =~ /(#{ENGINES.collect{|cat,regex| regex}.join(')|(')})/i
          # Matched group against comment
          chosen_content = { :name => nil, :version => nil }
          additional_groups = parse_comment(content[:comment])
          additional_groups.each do |additional_content|
            if additional_content[:name] =~ /(#{ENGINES.collect{|cat,regex| regex}.join(')|(')})/i
              chosen_content = additional_content
            end
          end

          populate(chosen_content)
        end
      end

      analysis
      
      self.browser = AgentOrange::Browser.new(user_agent)
    end

    # @return [Engine]
    def populate(content={})
      debug_raw_content(content)
      AgentOrange.debug "", 2

      self.type = determine_type(ENGINES, content[:name])
      self.name = ENGINES[type.to_sym]
      self.version = AgentOrange::Version.new(content[:version])
      self
    end

    # @return [String]
    def to_s
      [name, version].compact.join(' ') || "Unknown"
    end
  end
end
