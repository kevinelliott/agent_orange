class AgentOrange::Parser
  
  attr_accessor :user_agent_string
  attr_accessor :user_language
  
  def initialize(options = {}, &block)
    @user_agent_string = (options[:user_agent] || options[:ua]).to_s
    
    yield self if block_given?
  end
  
  def is_computer?
    
  end
  
  def is_mobile?
    
  end
  
  def is_bot?
  end
  
  def to_s
    "#{device.to_s}"
  end
  
end
