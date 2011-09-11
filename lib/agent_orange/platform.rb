module AgentOrange
  class Platform
    attr_accessor :type, :name, :version

    PLATFORMS = {
      :android => 'android',
      :ios => 'iphone|ipad|ipod',
      :mac => 'macintosh',
      :pc => 'freebsd|linux|netbsd|windows'
    }
    
    def initialize(user_agent)
      self.parse(user_agent)
    end
    
    def parse(user_agent)
      AgentOrange.debug "PLATFORM PARSING", 2
      groups = user_agent.scan(/([^\/[:space:]]*)(\/([^[:space:]]*))?([[:space:]]*\[[a-zA-Z][a-zA-Z]\])?[[:space:]]*(\((([^()]|(\([^()]*\)))*)\))?[[:space:]]*/i)
      groups.each_with_index do |pieces,i|
        name = pieces[0]
        version = pieces[2]
        comment = pieces[5]
        
        if comment =~ /(#{PLATFORMS.collect{|cat,regex| regex}.join(')|(')})/i
          # Found the device
          AgentOrange.debug "  Got a platform in group #{i+1}!", 2
          AgentOrange.debug "  Raw Name   : #{name}", 2
          AgentOrange.debug "  Raw Version: #{version}", 2
          AgentOrange.debug "  Raw Comment: #{comment}", 2
          AgentOrange.debug "", 2
                    
          # Determine platform type
          if comment =~ /(#{PLATFORMS[:android]})/i
            self.type = "android"
          end
          if comment =~ /(#{PLATFORMS[:ios]})/i
            self.type = "ios"
          end
          if comment =~ /(#{PLATFORMS[:mac]})/i
            self.type = "mac"
          end
          if comment =~ /(#{PLATFORMS[:pc]})/i
            self.type = "pc"
          end
          
          # Determine platform name
          self.name = comment.split(';')[0]
          
          # Determine platform version
          self.version = nil
        end

      end
      
      AgentOrange.debug "PLATFORM ANALYSIS", 2
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