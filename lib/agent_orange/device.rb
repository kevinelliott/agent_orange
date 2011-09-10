class AgentOrange::Device
  attr_accessor :name, :version
  
  def to_s
    "#{name} #{version}"
  end
end