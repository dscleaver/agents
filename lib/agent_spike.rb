require File.dirname(__FILE__) + '/agents'
require 'revactor'

def echo(name)
  Actor.receive do |filter|
    filter.when(Case[:message, :request, Object, :echo, Object]) do |msg|
      puts name + ": " + msg[4]
      echo(name)
    end
  end
end

def message_router(directory)
  Actor.receive do |filter|
    filter.when(Case[:register, Object, Object]) do |_, name, actor|
      message_router(directory.merge({ name => actor }))
    end
    filter.when(Case[:send, Object, Object]) do |_, receiver, message|
      directory[receiver] << message
      message_router(directory)
    end
  end

end

def message_receive(receivers)
  puts receivers.to_s
  Actor.receive do |filter|
    filter.when(Case[:listen, Object, Object]) do |msg|
      puts msg
      message_receive(receivers.merge({msg[1] => msg[2]}))
    end
    filter.when(Case[:message, Object, Object, Object, Object]) do |msg|
      puts msg[3]
      receivers[msg[3]] << msg
      message_receive(receivers)
    end
  end

end

$messages = Actor.spawn { message_router({}) }

def run_agent(name, setup) 
  msg = Actor.spawn_link { message_receive({}) }
  $messages << [:register, name, msg]

  setup.call(name, Actor.current, msg)

  Actor.receive { |filter| filter.when(:done) { |_| puts "Agent started" } }
end

def agent(name, &setup)
  puts("hi")
  run_agent(name, setup)
  puts("there")
end

agent("echo") do |name, agent, msg| 
  Actor.spawn_link do
    puts name + " " + msg.to_s
    msg << [:listen, :echo, Actor.current]
    agent << :done
    echo(name)
  end
end 

$messages << [:send, "echo", [:message, :request, "me", :echo, "echo this"]]
$messages << [:send, "echo", [:message, :request, "me", :echo, "hello world"]]

class AgentBacked
  
  def initialize
    @actor = Actor.spawn_link { run }
  end

  def query
    @actor << [:query, Actor.current]
    result = false
    Actor.receive { |filter| filter.when(Case[self, Object]) { |_, answer| result = answer }}
    result
  end

  private 
 
  def run
    puts "hey there"
    Actor.receive { |filter| filter.when(Case[:query, Object]) { |_, actor| actor << [self, true]; run } }
  end

end

backed = AgentBacked.new
puts "backed: " + backed.query.to_s

#Actor.receive { |filter| filter.when(:done) {|msg| puts "done"}}
