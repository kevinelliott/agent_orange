class AgentOrange::Version
  attr_accessor :major, :minor, :patch_level, :build_number
  
  def to_s
    "#{self.major}.#{self.minor}"
  end
end