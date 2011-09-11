require 'agent_orange/platform'
require 'agent_orange/engine'

module AgentOrange
  class Device
    attr_accessor :type, :name, :version
    attr_accessor :platform
    attr_accessor :operating_system
    attr_accessor :engine
    
    DEVICES = {
      :computer => 'windows|macintosh|x11|linux',
      :mobile => 'ipod|ipad|iphone|palm|android|opera mini|hiptop|windows ce|smartphone|mobile|treo|psp',
      :bot => 'bot'
    }
    
    def initialize(user_agent)
      self.parse(user_agent)
    end
    
    def parse(user_agent)
      AgentOrange.debug "DEVICE PARSING", 2
      groups = user_agent.scan(/([^\/[:space:]]*)(\/([^[:space:]]*))?([[:space:]]*\[[a-zA-Z][a-zA-Z]\])?[[:space:]]*(\((([^()]|(\([^()]*\)))*)\))?[[:space:]]*/i)
      groups.each_with_index do |pieces,i|
        name = pieces[0]
        version = pieces[2]
        comment = pieces[5]
        
        if comment =~ /(#{DEVICES.collect{|cat,regex| regex}.join(')|(')})/i
          # Found the device
          AgentOrange.debug "  Got a device in group #{i+1}!", 2
          AgentOrange.debug "  Group Raw Name   : #{name}", 2
          AgentOrange.debug "  Group Raw Version: #{version}", 2
          AgentOrange.debug "  Group Raw Comment: #{comment}", 2
          AgentOrange.debug "", 2
                    
          # Determine device type
          if comment =~ /(#{DEVICES[:computer]})/i
            self.type = "computer"
          end
          if comment =~ /(#{DEVICES[:mobile]})/i
            self.type = "mobile"
          end
          if comment =~ /(#{DEVICES[:bot]})/i
            self.type = "bot"
          end
          
          # Determine device name
          self.name = self.type.capitalize
          
          # Determine device version
          self.version = nil
          
        end

      end
      
      AgentOrange.debug "DEVICE ANALYSIS", 2
      AgentOrange.debug "  Type: #{self.type}", 2
      AgentOrange.debug "  Name: #{self.name}", 2
      AgentOrange.debug "  Version: #{self.version}", 2
      AgentOrange.debug "", 2
      
      self.platform = AgentOrange::Platform.new(user_agent)
      self.engine = AgentOrange::Engine.new(user_agent)
    end
    
    def is_computer?(name=nil)
      if name
        case name
        when String
          return self.name.downcase.include?(name.downcase)
        when Symbol
          return self.name.downcase.include?(name.to_s.downcase)
        end
      else
        (self.type == "computer")
      end
    end
    
    def is_mobile?(name=nil)
      if name
        case name
        when String
          return self.name.downcase.include?(name.downcase)
        when Symbol
          return self.name.downcase.include?(name.to_s.downcase)
        end
      else
        self.type == "mobile"
      end
    end
    
    def is_bot?(name=nil)
      if name
        case name
        when String
          return self.name.downcase.include?(name.downcase)
        when Symbol
          return self.name.downcase.include?(name.to_s.downcase)
        end
      else
        self.type == "bot"
      end
    end
    
    def to_s
      [self.name, self.version].compact.join(' ')
    end
  end
end