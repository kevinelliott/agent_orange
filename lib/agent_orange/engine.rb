require 'agent_orange/browser'

module AgentOrange
  class Engine
    attr_accessor :type, :name, :version
    attr_accessor :browser
    
    ENGINES = {
      :gecko  => 'Gecko',
      :presto => 'Presto',
      :webkit => 'AppleWebKit'
    }
    
    def initialize(user_agent)
      self.parse(user_agent)
    end
    
    def parse(user_agent)
      puts "ENGINE PARSING"
      groups = user_agent.scan(/([^\/[:space:]]*)(\/([^[:space:]]*))?([[:space:]]*\[[a-zA-Z][a-zA-Z]\])?[[:space:]]*(\((([^()]|(\([^()]*\)))*)\))?[[:space:]]*/i)
      groups.each_with_index do |pieces,i|
        name = pieces[0]
        version = pieces[2]
        comment = pieces[5]
        
        if name =~ /(#{ENGINES.collect{|cat,regex| regex}.join(')|(')})/i
          # Found the engine
          puts "  Got an engine in group #{i+1}!"
          puts "  Raw Name   : #{name}"
          puts "  Raw Version: #{version}"
          puts "  Raw Comment: #{comment}"
          puts
                    
          # Determine engine type
          if name =~ /(#{ENGINES[:gecko]})/i
            self.type = "gecko"
          end
          if name =~ /(#{ENGINES[:presto]})/i
            self.type = "presto"
          end
          if name =~ /(#{ENGINES[:webkit]})/i
            self.type = "webkit"
          end
          
          # Determine engine name
          self.name = name
          
          # Determine device version
          self.version = version
          
        end

      end
      
      puts "ENGINE ANALYSIS"
      puts "  Type: #{self.type}"
      puts "  Name: #{self.name}"
      puts "  Version: #{self.version}"
      puts
      
      self.browser = AgentOrange::Browser.new(user_agent)
    end
    
    def to_s
      [self.name, self.version].compact.join(' ')
    end
  end
end