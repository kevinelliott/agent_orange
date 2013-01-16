require 'agent_orange/base'

module AgentOrange
  class Platform < Base
    # @return [Symbol] one of the keys from {PLATFORMS}
    attr_accessor :type

    # @return [String] one of the values from {PLATFORM_NAMES}
    attr_accessor :name

    # @return [AgentOrange::Version]
    attr_accessor :version

    PLATFORMS = {
      :android => 'android',
      :apple => 'iphone|ipad|ipod',
      :mac => 'macintosh',
      :pc => 'freebsd|linux|netbsd|windows|x11'
    }

    PLATFORM_NAMES = {
      :android => 'Android',
      :apple => 'Apple',
      :mac => 'Macintosh',
      :pc => 'PC'
    }

    PLATFORM_VERSIONS = {
      :ipad => 'ipad',
      :iphone => 'iphone',
      :ipod => 'ipod'
    }

    def parse(user_agent)
      AgentOrange.debug "PLATFORM PARSING", 2

      groups = parse_user_agent_string_into_groups(user_agent)
      groups.each_with_index do |content,i|
        if content[:comment] =~ /(#{PLATFORMS.collect{|cat,regex| regex}.join(')|(')})/i
          # Matched group against name
          populate(content)
        end
      end

      analysis
    end

    # @return [Platform]
    def populate(content={})
      debug_raw_content(content)
      AgentOrange.debug "", 2

      self.type = determine_type(PLATFORMS, content[:comment])
      self.name = PLATFORM_NAMES[type.to_sym]

      if type == :apple
        self.version = case determine_type(PLATFORM_VERSIONS, content[:comment])
        when :ipad
          AgentOrange::Version.new("iPad")
        when :iphone
          AgentOrange::Version.new("iPhone")
        when :ipod
          AgentOrange::Version.new("iPod")
        else
          AgentOrange::Version.new("Unknown")
        end
      else
        self.version = nil
      end

      self
    end

    def to_s
      [name, version].compact.join(' ')
    end
  end
end
