module AgentOrange
  class Browser
    attr_accessor :name, :version
  
    def to_s
      "#{self.name} #{self.version}"
    end
  end
end