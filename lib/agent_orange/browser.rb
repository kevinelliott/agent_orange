module AgentOrange
  class Browser
    attr_accessor :type, :name, :version
    attr_accessor :security
    
    BROWSERS = {
      :ie       => 'MSIE|Internet Explorer|IE',
      :firefox  => 'Firefox',
      :safari   => 'Safari'
    }
    
    def initialize(user_agent)
      self.parse(user_agent)
    end
    
    def parse(user_agent)
      puts "BROWSER PARSING"
      groups = user_agent.scan(/([^\/[:space:]]*)(\/([^[:space:]]*))?([[:space:]]*\[[a-zA-Z][a-zA-Z]\])?[[:space:]]*(\((([^()]|(\([^()]*\)))*)\))?[[:space:]]*/i)
      groups.each_with_index do |pieces,i|
        name = pieces[0]
        version = pieces[2]
        comment = pieces[5]
        
        if name =~ /(#{BROWSERS.collect{|cat,regex| regex}.join(')|(')})/i
          # Found the browser          
          puts "  Got a browser in group #{i+1}!"
          puts "  Raw Name   : #{name}"
          puts "  Raw Version: #{version}"
          puts "  Raw Comment: #{comment}"
          puts
          
          # Determine browser type
          if name =~ /(#{BROWSERS[:ie]})/i
            self.type = "ie"
          elsif name =~ /(#{BROWSERS[:firefox]})/i
            self.type = "firefox"
          elsif name =~ /(#{BROWSERS[:safari]})/i
            self.type = "safari"
          else
            self.type = "other"
          end
          
          # Determine browser name
          self.name = name
          
          # Determine device version
          self.version = version
          
        end

      end
      
      puts "BROWSER ANALYSIS"
      puts "  Type: #{self.type}"
      puts "  Name: #{self.name}"
      puts "  Version: #{self.version}"
      puts
    end
    
    def to_s
      [self.name, self.version].join(' ')
    end
  end
end