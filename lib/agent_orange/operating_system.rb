require 'agent_orange/base'

module AgentOrange
  class OperatingSystem < Base
    attr_accessor :type, :name, :version

    OPERATING_SYSTEMS = {
      :android => 'android',
      :freebsd => 'freebsd',
      :ios => 'iphone|ipad|ipod',
      :linux => 'linux',
      :netbsd => 'netbsd',
      :osx => 'osx|os x',
      :windows => 'windows'
    }

    OPERATING_SYSTEM_NAMES = {
      :android => 'Android',
      :freebsd => 'FreeBSD',
      :ios => 'Apple iOS',
      :linux => 'Linux',
      :netbsd => 'NetBSD',
      :osx => 'Mac OS X',
      :windows => 'Windows'
    }

    def parse(user_agent)
      AgentOrange.debug "OPERATING SYSTEM PARSING", 2

      groups = parse_user_agent_string_into_groups(user_agent)
      groups.each_with_index do |content,i|
        if content[:comment] =~ /(#{OPERATING_SYSTEMS.collect{|cat,regex| regex}.join(')|(')})/i
          # Matched group against comment
          chosen_content = { :name => nil, :version => nil }
          additional_groups = parse_comment(content[:comment])
          additional_groups.each do |additional_content|
            if additional_content[:name] =~ /(#{OPERATING_SYSTEMS.collect{|cat,regex| regex}.join(')|(')})/i
              chosen_content = additional_content
            end
          end

          self.populate(chosen_content)
        end
      end

      self.analysis
    end

    def populate(content={})
      self.debug_raw_content(content)
      AgentOrange.debug "", 2

      self.type = self.determine_type(OPERATING_SYSTEMS, content[:name])
      self.name = OPERATING_SYSTEM_NAMES[self.type.to_sym]
      self.version = AgentOrange::Version.new(content[:version])
      self
    end

    def analysis
      AgentOrange.debug "OPERATING SYSTEM ANALYSIS", 2
      self.debug_content(:type => self.type, :name => self.name, :version => self.version)
      AgentOrange.debug "", 2
    end

    def to_s
      [self.name, self.version].compact.join(' ')
    end
  end
end
