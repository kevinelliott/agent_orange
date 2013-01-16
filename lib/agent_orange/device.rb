require 'agent_orange/base'
require 'agent_orange/platform'
require 'agent_orange/operating_system'
require 'agent_orange/engine'
require 'agent_orange/version'

module AgentOrange
  class Device < Base
    # @return [Symbol] one of the keys from {DEVICES}
    attr_accessor :type

    # @return [String]
    attr_accessor :name

    # @return [AgentOrange::Version]
    attr_accessor :version

    # @return [Boolean]
    attr_accessor :bot

    # @return [AgentOrange::Platform]
    attr_accessor :platform

    # @return [AgentOrange::OperatingSystem]
    attr_accessor :operating_system

    # @return [AgentOrange::Engine]
    attr_accessor :engine

    DEVICES = {
      :computer => 'windows|macintosh|x11|linux',
      :mobile => 'ipod|ipad|iphone|palm|android|opera mini|hiptop|windows ce|smartphone|mobile|treo|psp'
    }

    BOTS = {
      :bot => 'alexa|bot|crawl(er|ing)|facebookexternalhit|feedburner|google web preview|nagios|postrank|pingdom|slurp|spider|yahoo!|yandex'
    }

    def parse(user_agent)
      AgentOrange.debug "DEVICE PARSING", 2

      groups = parse_user_agent_string_into_groups(user_agent)
      groups.each_with_index do |content,i|
        devices_and_bots = DEVICES.merge(BOTS)
        if content[:comment] =~ /(#{devices_and_bots.collect{|cat,regex| regex}.join(')|(')})/i
          # Matched group against name
          self.populate(content)
        end
      end

      analysis

      self.platform         = AgentOrange::Platform.new(user_agent)
      self.operating_system = AgentOrange::OperatingSystem.new(user_agent)
      self.engine           = AgentOrange::Engine.new(user_agent)
    end

    # @return [Device]
    def populate(content={})
      debug_raw_content(content)
      AgentOrange.debug "", 2

      self.type = determine_type(DEVICES, content[:comment])
      self.bot  = determine_type(BOTS, content[:comment]) == :bot
      if (bot && type == "other")
        self.type = :bot # backwards compatability
      end
      self.name = type.to_s.capitalize
      self.version = nil
      self
    end

    # @return [Boolean]
    def is_computer?(name=nil)
      if name
        case name
        when String
          return platform.name.downcase.include?(name.downcase)
        when Symbol
          return platform.name.downcase.include?(name.to_s.downcase)
        end
      else
        (type == :computer)
      end
    end

    # @return [Boolean]
    def is_mobile?(name=nil)
      if !name.nil? && !platform.name.nil?
        case name
        when String
          return platform.name.downcase.include?(name.downcase) || platform.version.downcase.include?(name.downcase)
        when Symbol
          return platform.name.downcase.include?(name.to_s.downcase) || platform.version.to_s.downcase.include?(name.to_s.downcase)
        end
      else
        (type == :mobile)
      end
    end

    # @return [Boolean]
    def is_bot?(name=nil)
      if name
        case name
        when String
          return name.downcase.include?(name.downcase)
        when Symbol
          return name.downcase.include?(name.to_s.downcase)
        end
      else
        bot
      end
    end

    # @return [String]
    def to_s
      [name, version].compact.join(' ')
    end
  end
end
