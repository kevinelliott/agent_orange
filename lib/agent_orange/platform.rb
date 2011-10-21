require 'agent_orange/base'

module AgentOrange
  class Platform < Base
    attr_accessor :type, :name, :version

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

      if self.type == :apple
        self.version = case self.determine_type(PLATFORM_VERSIONS, content[:comment])
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
