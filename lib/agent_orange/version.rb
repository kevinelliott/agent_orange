module AgentOrange
  VERSION = "0.0.2" # This is for the gem and does not conflict with the rest of the functionality
  
  class Version
    attr_accessor :major, :minor, :patch_level, :build_number
  
    def to_s
      "#{self.major}.#{self.minor}"
    end
  end
end