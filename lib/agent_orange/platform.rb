require 'agent_orange/base'

module AgentOrange
  class Platform < Base
    attr_accessor :type, :name, :version

    PLATFORMS = {
      :android => 'android',
      :ios => 'iphone|ipad|ipod',
      :mac => 'macintosh',
      :pc => 'freebsd|linux|netbsd|windows|x11'
    }
    
    PLATFORM_NAMES = {
      :android => 'Android',
      :ios => 'iOS',
      :mac => 'Macintosh',
      :pc => 'PC'
    }
    
    def old_parse(user_agent)
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
          self.name = PLATFORM_NAMES[self.type.to_sym]
          
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
    
    def parse(user_agent)
      AgentOrange.debug "PLATFORM PARSING", 2
      
      groups = parse_user_agent_string_into_groups(user_agent)
      groups.each_with_index do |content,i|
        if content[:comment] =~ /(#{PLATFORMS.collect{|cat,regex| regex}.join(')|(')})/i
          # Matched group against name
          self.populate(content)
        end
      end
      
      self.analysis
    end
    
    def populate(content={})
      self.debug_raw_content(content)
      AgentOrange.debug "", 2
      
      self.type = self.determine_type(PLATFORMS, content[:comment])
      self.name = PLATFORM_NAMES[self.type.to_sym]
      self.version = nil
      self
    end
    
    def analysis
      AgentOrange.debug "PLATFORM ANALYSIS", 2
      self.debug_content(:type => self.type, :name => self.name, :version => self.version)
      AgentOrange.debug "", 2
    end
    
    def to_s
      [self.name, self.version].compact.join(' ')
    end
  end
end