require 'agent_orange/base'
require 'agent_orange/browser'
require 'agent_orange/version'
require 'pp'

module AgentOrange
  class Engine < Base
    attr_accessor :type, :name, :version
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
          self.populate(content)
        elsif content[:comment] =~ /(#{ENGINES.collect{|cat,regex| regex}.join(')|(')})/i
          # Matched group against comment
          chosen_content = { :name => nil, :version => nil }
          additional_groups = parse_comment(content[:comment])
          additional_groups.each do |additional_content|
            if additional_content[:name] =~ /(#{ENGINES.collect{|cat,regex| regex}.join(')|(')})/i
              chosen_content = additional_content
            end
          end

          self.populate(chosen_content)
        end
      end

      self.analysis
      self.browser = AgentOrange::Browser.new(user_agent)
    end

    def populate(content={})
      self.debug_raw_content(content)
      AgentOrange.debug "", 2

      self.type = self.determine_type(ENGINES, content[:name])
      self.name = ENGINES[self.type.to_sym]
      self.version = AgentOrange::Version.new(content[:version])
      self
    end

    def analysis
      AgentOrange.debug "ENGINE ANALYSIS", 2
      self.debug_content(:type => self.type, :name => self.name, :version => self.version)
      AgentOrange.debug "", 2
    end

    def to_s
      [self.name, self.version].compact.join(' ') || "Unknown"
    end
  end
end
