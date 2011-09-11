module AgentOrange
  class Platform
    attr_accessor :name, :version
    
    def to_s
      "#{name} #{version}
    end
  end
end