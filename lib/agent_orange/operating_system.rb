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

    def old_parse(user_agent)
      AgentOrange.debug "OPERATING SYSTEM PARSING", 2
      groups = user_agent.scan(/([^\/[:space:]]*)(\/([^[:space:]]*))?([[:space:]]*\[[a-zA-Z][a-zA-Z]\])?[[:space:]]*(\((([^()]|(\([^()]*\)))*)\))?[[:space:]]*/i)
      groups.each_with_index do |pieces,i|
        name = pieces[0]
        version = pieces[2]
        comment = pieces[5]

        if comment =~ /(#{OPERATING_SYSTEMS.collect{|cat,regex| regex}.join(')|(')})/i
          # Found the operating system
          AgentOrange.debug "  Got an operating system in group #{i+1}!", 2
          AgentOrange.debug "  Raw Name   : #{name}", 2
          AgentOrange.debug "  Raw Version: #{version}", 2
          AgentOrange.debug "  Raw Comment: #{comment}", 2
          AgentOrange.debug "", 2

          # Determine operating system type
          if comment =~ /(#{OPERATING_SYSTEMS[:android]})/i
            self.type = "android"
          end
          if comment =~ /(#{OPERATING_SYSTEMS[:freebsd]})/i
            self.type = "freebsd"
          end
          if comment =~ /(#{OPERATING_SYSTEMS[:ios]})/i
            self.type = "ios"
          end
          if comment =~ /(#{OPERATING_SYSTEMS[:linux]})/i
            self.type = "linux"
          end
          if comment =~ /(#{OPERATING_SYSTEMS[:netbsd]})/i
            self.type = "netbsd"
          end
          if comment =~ /(#{OPERATING_SYSTEMS[:osx]})/i
            self.type = "osx"
          end
          if comment =~ /(#{OPERATING_SYSTEMS[:windows]})/i
            self.type = "windows"
          end

          # Determine operating system name
          self.name = OPERATING_SYSTEM_NAMES[self.type.to_sym]

          # Determine operating system version
          self.version = nil
        end

      end

      AgentOrange.debug "OPERATING SYSTEM ANALYSIS", 2
      AgentOrange.debug "  Type: #{self.type}", 2
      AgentOrange.debug "  Name: #{self.name}", 2
      AgentOrange.debug "  Version: #{self.version}", 2
      AgentOrange.debug "", 2
    end

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