require 'agent_orange/browser'
require 'agent_orange/version'

module AgentOrange
  class Engine
    attr_accessor :type, :name, :version
    attr_accessor :browser
    
    ENGINES = {
      :gecko  => 'Gecko',
      :presto => 'Presto',
      :webkit => 'AppleWebKit'
    }
    
    def initialize(user_agent)
      self.parse(user_agent)
    end
    
    def parse(user_agent)
      AgentOrange.debug "ENGINE PARSING", 2
      groups = user_agent.scan(/([^\/[:space:]]*)(\/([^[:space:]]*))?([[:space:]]*\[[a-zA-Z][a-zA-Z]\])?[[:space:]]*(\((([^()]|(\([^()]*\)))*)\))?[[:space:]]*/i)
      groups.each_with_index do |pieces,i|
        name = pieces[0]
        version = pieces[2]
        comment = pieces[5]
        
        if name =~ /(#{ENGINES.collect{|cat,regex| regex}.join(')|(')})/i
          # Found the engine
          AgentOrange.debug "  Got an engine in group #{i+1}!", 2
          AgentOrange.debug "  Raw Name   : #{name}", 2
          AgentOrange.debug "  Raw Version: #{version}", 2
          AgentOrange.debug "  Raw Comment: #{comment}", 2
          AgentOrange.debug "", 2
                    
          # Determine engine type
          if name =~ /(#{ENGINES[:gecko]})/i
            self.type = "gecko"
          end
          if name =~ /(#{ENGINES[:presto]})/i
            self.type = "presto"
          end
          if name =~ /(#{ENGINES[:webkit]})/i
            self.type = "webkit"
          end
          
          # Determine engine name
          self.name = name
          
          # Determine device version
          self.version = AgentOrange::Version.new(version)
          
        end

      end
      
      AgentOrange.debug "ENGINE ANALYSIS", 2
      AgentOrange.debug "  Type: #{self.type}", 2
      AgentOrange.debug "  Name: #{self.name}", 2
      AgentOrange.debug "  Version: #{self.version}", 2
      AgentOrange.debug "", 2
      
      self.browser = AgentOrange::Browser.new(user_agent)
    end
    
    def to_s
      [self.name, self.version].compact.join(' ')
    end
  end
end