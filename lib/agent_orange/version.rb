module AgentOrange
  VERSION = "0.0.3" # This is for the gem and does not conflict with the rest of the functionality
  
  class Version
    attr_accessor :major, :minor, :patch_level, :build_number

    def initialize(version_string)
      self.major = nil
      self.minor = nil
      self.patch_level = nil
      self.build_number = nil

      pieces = version_string.split('.')
      case pieces.count
      when 1
        self.major = pieces[0]
      when 2
        self.major = pieces[0]
        self.minor = pieces[1]
      when 3
        self.major = pieces[0]
        self.minor = pieces[1]
        self.patch_level = pieces[2]
      when 4
        self.major = pieces[0]
        self.minor = pieces[1]
        self.patch_level = pieces[2]
        self.build_number = pieces[3]
      end
    end
    
    def to_s
      [self.major, self.minor, self.patch_level, self.build_number].compact.join('.')
    end
  end
end