module AgentOrange
  class Engine
    attr_accessor :name, :version
  
    def to_s
      "#{name} #{version}"
    end
  end
end