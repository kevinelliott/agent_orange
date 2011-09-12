require 'agent_orange/browser'
require 'agent_orange/version'
require 'pp'

module AgentOrange
  class Engine
    attr_accessor :type, :name, :version
    attr_accessor :browser
    
    ENGINES = {
      :gecko  => 'Gecko',
      :presto => 'Presto',
      :trident => 'Trident',
      :webkit => 'AppleWebKit',
      :other => 'Other'
    }
    
    def initialize(user_agent)
      self.parse(user_agent)
    end
    
    def parse(user_agent)
      AgentOrange.debug "ENGINE PARSING", 2
      results = user_agent.scan(/([^\/[:space:]]*)(\/([^[:space:]]*))?([[:space:]]*\[[a-zA-Z][a-zA-Z]\])?[[:space:]]*(\((([^()]|(\([^()]*\)))*)\))?[[:space:]]*/i)
      groups = regex_results_into_groups(results)
      groups.each_with_index do |content,i|
        if content[:name] =~ /(#{ENGINES.collect{|cat,regex| regex}.join(')|(')})/i
          # Matched group
          self.populate_by(:name, content)
        elsif content[:comment] =~ /(#{ENGINES.collect{|cat,regex| regex}.join(')|(')})/i
          # Matched group
          self.populate_by(:comment, content)
        end
      end
      
      self.analysis
      self.browser = AgentOrange::Browser.new(user_agent)
    end
    
    def regex_results_into_groups(results)
      groups = []
      results.each do |result|
        if result[0] != ""
          groups << { :name => result[0], :version => result[2], :comment => result[5] }
        end
      end
      groups
    end
    
    def determine_type(content="")
      # Determine type
      type = nil
      ENGINES.each do |key, value|
        type = key if content =~ /(#{value})/i
      end
      type = "other" if type.nil?
      type
    end
    
    def populate_by(key=:name, content={})
      AgentOrange.debug "  Raw Name   : #{content[:name]}", 2
      AgentOrange.debug "  Raw Version: #{content[:version]}", 2
      AgentOrange.debug "  Raw Comment: #{content[:comment]}", 2
      AgentOrange.debug "", 2
                
      self.type = self.determine_type(content[key])
      
      # Determine name
      self.name = ENGINES[self.type.to_sym]
      
      # Determine version
      self.version = AgentOrange::Version.new(content[:version])
      self
    end
    
    def analysis
      AgentOrange.debug "ENGINE ANALYSIS", 2
      AgentOrange.debug "  Type: #{self.type}", 2
      AgentOrange.debug "  Name: #{self.name}", 2
      AgentOrange.debug "  Version: #{self.version}", 2
      AgentOrange.debug "", 2
    end
    
    def to_s
      [self.name, self.version].compact.join(' ') || "Unknown"
    end
  end
end