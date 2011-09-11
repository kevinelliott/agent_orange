require 'agent_orange/device'

module AgentOrange
  class UserAgent
    attr_accessor :user_agent_string
    attr_accessor :user_language
    attr_accessor :device
    
    ENGINES = {
    }
    
    BROWSERS = {
    }
    
    def initialize(options = {}, &block)
      @user_agent_string = options[:user_agent].to_s
      self.parse(@user_agent_string)
      
      yield self if block_given?
    end

    def parse(user_agent)      
      self.device = AgentOrange::Device.new(user_agent)

      puts
      puts "Device = #{self.device}"
      puts "Is computer? #{self.is_computer?}"
      puts "Is mobile? #{self.is_mobile?}"
      puts "Is bot? #{self.is_bot?}"
      puts
      
      puts "Engine = #{self.device.engine}"
      puts
      
      puts "Browser = #{self.device.engine.browser}"
      puts
      
      puts "user_agent.to_s = #{self}"
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
end