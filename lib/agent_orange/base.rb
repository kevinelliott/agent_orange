module AgentOrange
  class Base
    
    def initialize(user_agent)
      self.parse(user_agent)
    end
    
    def parse_user_agent_string_into_groups(user_agent)
      results = user_agent.scan(/([^\/[:space:]]*)(\/([^[:space:]]*))?([[:space:]]*\[[a-zA-Z][a-zA-Z]\])?[[:space:]]*(\((([^()]|(\([^()]*\)))*)\))?[[:space:]]*/i)
      groups = []
      results.each do |result|
        if result[0] != "" # Add the group of content if name isn't blank
          groups << { :name => result[0], :version => result[2], :comment => result[5] }
        end
      end
      groups
    end
    
    def parse_comment(comment)
      groups = []
      comment.split('; ').each do |piece|
        content = { :name => nil, :version => nil }
        
        # Remove 'like Mac OS X' or similar since it distracts from real results
        piece = piece.scan(/(.+) like .+$/i)[0][0] if piece =~ /(.+) like (.+)$/i
        
        if piece =~ /(.+)[ \/]([\w.]+)$/i
          chopped = piece.scan(/(.+)[ \/]([\w.]+)$/i)[0]
          groups << { :name => chopped[0], :version => chopped[1] }
        end
      end
      groups
    end

    def determine_type(types={}, content="")
      # Determine type
      type = nil
      types.each do |key, value|
        type = key if content =~ /(#{value})/i
      end
      type = "other" if type.nil?
      type
    end
    
    def debug_raw_content(content)
      AgentOrange.debug "  Raw Name   : #{content[:name]}", 2
      AgentOrange.debug "  Raw Version: #{content[:version]}", 2
      AgentOrange.debug "  Raw Comment: #{content[:comment]}", 2
    end
    
    def debug_content(content)
      AgentOrange.debug "  Type: #{self.type}", 2
      AgentOrange.debug "  Name: #{self.name}", 2
      AgentOrange.debug "  Version: #{self.version}", 2
    end
    
  end
end