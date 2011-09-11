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
      groups = user_agent.scan(/([^\/[:space:]]*)(\/([^[:space:]]*))?([[:space:]]*\[[a-zA-Z][a-zA-Z]\])?[[:space:]]*(\((([^()]|(\([^()]*\)))*)\))?[[:space:]]*/i)
      groups.each_with_index do |pieces,i|
        name = pieces[0]
        version = pieces[2]
        comment = pieces[5]
        puts
        puts "GROUP #{i+1}"
        puts "  PARSED"
        puts "  Name   : #{name}"
        puts "  Version: #{version}"
        puts "  Comment: #{comment}"
        puts
        
        if comment =~ /(#{DEVICES.collect{|cat,regex| regex}.join(')|(')})/i
          # Found the device
          puts "  Got a device!"
          
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
          self.name = comment.split(';')[0]
          
          # Determine device version
          self.version = nil
          
        end

      end
      
      puts "DEVICE ANALYSIS"
      puts "  Type: #{self.type}"
      puts "  Name: #{self.name}"
      puts "  Version: #{self.version}"
      
      self.engine = AgentOrange::Engine.new(user_agent)
    end
    
    def is_computer?(type=nil)
      self.type == "computer"
    end
    
    def is_mobile?(type=nil)
      self.type == "mobile"
    end
    
    def is_bot?(type=nil)
      self.type == "bot"
    end
    
    def to_s
      [self.name, self.version].join(' ')
    end
  end
end