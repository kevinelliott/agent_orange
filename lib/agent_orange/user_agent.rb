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
      puts "User-Agent: #{user_agent}"
      self.device = AgentOrange::Device.new(user_agent)

      puts
      puts "Device = #{self.device}"
      puts "Is computer? #{self.is_computer?}"
      puts "Is mobile? #{self.is_mobile?}"
      puts "Is bot? #{self.is_bot?}"
      puts
      puts "Engine = #{self.device.engine}"
      
    end
    
    def is_computer?(type=nil)
      self.device.is_computer?
    end

    def is_mobile?(type=nil)
      self.device.is_mobile?
    end

    def is_bot?(type=nil)
      self.device.is_bot?
    end

    def to_s
      "#{device.to_s}"
    end

  end
end