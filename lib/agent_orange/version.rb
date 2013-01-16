module AgentOrange
  VERSION = "0.1.6" # This is for the gem and does not conflict with the rest of the functionality

  class Version
    # @return [String, nil]
    attr_accessor :major

    # @return [String, nil]
    attr_accessor :minor

    # @return [String, nil]
    attr_accessor :patch_level

    # @return [String, nil]
    attr_accessor :build_number

    def initialize(version_string)
      version_string = sanitize_version_string(version_string)
      self.major        = nil
      self.minor        = nil
      self.patch_level  = nil
      self.build_number = nil

      pieces       = version_string.split('.')
      pieces_count = pieces.count

      self.major        = pieces[0] if pieces_count >= 1
      self.minor        = pieces[1] if pieces_count >= 2
      self.patch_level  = pieces[2] if pieces_count >= 3
      self.build_number = pieces[3] if pieces_count >= 4
    end

    # @return [String]
    def to_s
      [major, minor, patch_level, build_number].compact.join('.')
    end

    private

    def sanitize_version_string(version_string)
      unless version_string.nil?
        version_string.gsub('_','.')
      else
        ""
      end
    end
  end
end
