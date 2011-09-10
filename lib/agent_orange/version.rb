class AgentOrange::Version
  VERSION = "0.0.1" # This is for the gem and does not conflict with the rest of the functionality

  attr_accessor :major, :minor, :patch_level, :build_number
  
  def to_s
    "#{self.major}.#{self.minor}"
  end
end