require 'agent_orange/device'

module AgentOrange
  DEBUG = true
  DEBUG_LEVEL = 1
  
  class UserAgent
    attr_accessor :user_agent_string
    attr_accessor :user_language
    attr_accessor :device
    
    def initialize(options = {}, &block)
      @user_agent_string = options[:user_agent].to_s
      self.parse(@user_agent_string)
      
      yield self if block_given?
    end

    def parse(user_agent)      
      self.device = AgentOrange::Device.new(user_agent)

      AgentOrange.debug "Device = #{self.device}"
      AgentOrange.debug "  Is computer? #{self.is_computer?}"
      AgentOrange.debug "  Is mobile? #{self.is_mobile?}"
      AgentOrange.debug "  Is bot? #{self.is_bot?}"
      AgentOrange.debug
      
      AgentOrange.debug "Engine = #{self.device.engine}"
      AgentOrange.debug "Browser = #{self.device.engine.browser}"
      AgentOrange.debug
      
      AgentOrange.debug "user_agent.to_s = #{self}", 2
    end
    
    def is_computer?(type=nil)
      self.device.is_computer?(type)
    end

    def is_mobile?(type=nil)
      self.device.is_mobile?(type)
    end

    def is_bot?(type=nil)
      self.device.is_bot?(type)
    end

    def to_s
      [self.device, self.device.engine, self.device.engine.browser].compact.join(", ")
    end
    
    def to_human_string
      if self.device && self.device.engine && self.device.engine.browser
        "User has a #{self.device} running #{self.device.engine.browser} (which is based on #{self.device.engine})."
      else
        "User has some kind of device that I've never seen."
      end
    end

  end
  
  def self.debug(str="", level=1)
    puts str if DEBUG && (DEBUG_LEVEL >= level)
  end
  
end