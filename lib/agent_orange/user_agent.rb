require 'agent_orange/device'

module AgentOrange
  DEBUG = false
  DEBUG_LEVEL = 1

  class UserAgent
    # @return [String]
    attr_accessor :user_agent_string

    attr_accessor :user_language

    # @return [AgentOrange::Device]
    attr_accessor :device

    # @param [String] user_agent_string
    def initialize(user_agent_string)
      parse(user_agent_string)
    end

    def parse(user_agent)
      self.user_agent_string = user_agent
      self.device = AgentOrange::Device.new(user_agent_string)

      AgentOrange.debug "Device   = #{device}"
      AgentOrange.debug "Platform = #{device.platform}"
      AgentOrange.debug "OS       = #{device.operating_system}"
      AgentOrange.debug "Engine   = #{device.engine}"
      AgentOrange.debug "Browser  = #{device.engine.browser}"

      summary
    end

    # @return [Boolean]
    def is_computer?(type=nil)
      device.is_computer?(type)
    end

    # @return [Boolean]
    def is_mobile?(type=nil)
      device.is_mobile?(type)
    end

    # @return [Boolean]
    def is_bot?(type=nil)
      device.is_bot?(type)
    end

    # @return [String]
    def to_s
      [
        device,
        device.platform,
        device.operating_system,
        device.engine,
        device.engine.browser
      ].compact.join(", ")
    end

    # @return [String]
    def to_human_string
      if device && device.engine && device.engine.browser
        "User has a #{device} running #{device.engine.browser} (which is based on #{device.engine})."
      else
        "User has some kind of device that I've never seen."
      end
    end

    def summary
      AgentOrange.debug
      AgentOrange.debug "SUMMARY"
      AgentOrange.debug "  Is computer? #{is_computer?}"
      if is_computer?
        AgentOrange.debug "    Is a Mac? #{is_computer? :mac}"
        AgentOrange.debug "    Is a PC? #{is_computer? :pc}"
      end
      AgentOrange.debug "  Is mobile? #{is_mobile?}"
      if is_mobile?
        AgentOrange.debug "    Is an iPhone? #{is_mobile? :iphone}"
        AgentOrange.debug "    Is an iPad? #{is_mobile? :ipad}"
        AgentOrange.debug "    Is an iPod? #{is_mobile? :ipod}"
        AgentOrange.debug "    Is an Android? #{is_mobile? :android}"
      end
      AgentOrange.debug "  Is bot? #{is_bot?}"
      AgentOrange.debug
    end
  end

  def self.debug(str="", level=1)
    puts str if DEBUG && (DEBUG_LEVEL >= level)
  end

end
