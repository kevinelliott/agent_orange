require 'agent_orange/version'

module AgentOrange
  class Browser
    attr_accessor :type, :name, :version
    attr_accessor :security
    
    BROWSERS = {
      :ie       => 'MSIE|Internet Explorer|IE',
      :firefox  => 'Firefox',
      :opera    => 'Opera',
      :safari   => 'Safari'
    }
    
    def initialize(user_agent)
      self.parse(user_agent)
    end
    
    def parse(user_agent)
      AgentOrange.debug "BROWSER PARSING", 2
      groups = user_agent.scan(/([^\/[:space:]]*)(\/([^[:space:]]*))?([[:space:]]*\[[a-zA-Z][a-zA-Z]\])?[[:space:]]*(\((([^()]|(\([^()]*\)))*)\))?[[:space:]]*/i)
      groups.each_with_index do |pieces,i|
        name = pieces[0]
        version = pieces[2]
        comment = pieces[5]
        
        if name =~ /(#{BROWSERS.collect{|cat,regex| regex}.join(')|(')})/i
          # Found the browser          
          AgentOrange.debug "  Got a browser in group #{i+1}!", 2
          AgentOrange.debug "  Raw Name   : #{name}", 2
          AgentOrange.debug "  Raw Version: #{version}", 2
          AgentOrange.debug "  Raw Comment: #{comment}", 2
          AgentOrange.debug "", 2
          
          # Determine browser type
          if name =~ /(#{BROWSERS[:ie]})/i
            self.type = "ie"
          elsif name =~ /(#{BROWSERS[:firefox]})/i
            self.type = "firefox"
          elsif name =~ /(#{BROWSERS[:safari]})/i
            self.type = "safari"
          elsif name =~ /(#{BROWSERS[:opera]})/i
            self.type = "opera"
          else
            self.type = "other"
          end
          
          # Determine browser name
          self.name = name
          
          # Determine device version
          self.version = AgentOrange::Version.new(version)
          
        end

      end
      
      AgentOrange.debug "BROWSER ANALYSIS", 2
      AgentOrange.debug "  Type: #{self.type}", 2
      AgentOrange.debug "  Name: #{self.name}", 2
      AgentOrange.debug "  Version: #{self.version}", 2
      AgentOrange.debug "", 2
    end
    
    def to_s
      [self.name, self.version].compact.join(' ')
    end
  end
end