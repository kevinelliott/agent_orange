class RSpec::Core::ExampleGroup

  class << self

    def detect(user_agent, &block)
      klass = self.describes
      subject = klass.new(user_agent)
      it(user_agent) do
        yield subject
      end
    end

  end
end


