class AgentMessage

  attr_accessor :performative, :sender, :receiver, :in_reply_to, :reply_with  

  def self.performatives(*performatives)
    performatives.each do |performative|
      self.module_eval "def self.#{performative}(args) message = AgentMessage.new(:#{performative}); message.fields = args; return message; end"
    end
  end

  performatives :inform, :request 

  def initialize(perf)
    @performative = perf
  end

  def reply(performative, newVals)
    params = {}
    params[:receiver] = receiver
    params[:in_reply_to] = reply_with

    message = AgentMessage.send(performative, params)
    message.fields = newVals
    return message
  end

  def fields=(fields) 
    fields.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def to_s
    str = "(" + performative.to_s
    instance_variables.each do |var|
      val = instance_variable_get(var)
      str << " :" + var[1..-1] + " " + val.to_s unless var == "@performative" || val == nil
    end
    str << ")"
    return str
  end

end

def main(*args)
  puts "here"
  message = AgentMessage.request :sender => "bob", :receiver => :jerry, :reply_with => 20
  puts message
  puts message.reply :inform, :sender => "me"
end

main
