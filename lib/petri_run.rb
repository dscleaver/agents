require File.dirname(__FILE__) + '/agents'

net = PetriNet::PetriNet.new()

class Chain

  attr_accessor :name

  def initialize(name)
    @name = name
    @subchains = []
  end

  def >>(sub)
    if sub.kind_of?(Array)
      @subchains << MultiChain.new(sub)
    else
      @subchains << sub
    end
    self
  end

  def **(net)

    input = net.add_place


    build(input, net)

    input

  end

  def build(input, net)
    puts @name
    output = net.add_place
    
    net.add_transition([input], @name, [output])

    build_sub_chains(output, net)
  end

  def build_sub_chains(output, net)
    for chain in @subchains
      output = chain.build(output, net)
    end

    output
  end

end

class MultiChain < Chain
  
  def initialize(chains)
    @chains = chains
    @subchains = []
  end

  def build(input, net)
    outputs = Array.new(@chains.length) { |_| net.add_place }

    net.add_transition([input], "split", outputs)

    chain_outputs = []

    @chains.length.times do |i|

      chain_outputs << @chains[i].build(outputs[i], net)
 
    end

    output = net.add_place

    net.add_transition(chain_outputs, "join", [output])

    build_sub_chains(output, net)
  end

end

def transition(name)
  Chain.new(name)
end

chain = transition("Transition 1") >> [ transition("Transition 2") >> [transition("Transition 5"), transition("Transition 6")] >> transition("Transition 7"), transition("Transition 3") ] >> transition("Transition 4")

start = chain ** net

puts "Placing token in " + start.to_s

net.place_token(start, "Token");

while not net.active_transitions.empty? do

  transition = net.active_transitions[0]

  puts "Executing " + transition

  net.choose_transition(transition)

  outputs = net.outputs_for(transition)

  puts "Placing tokens in " + outputs.to_s

  for output in outputs
    net.place_token(output, "Token")
  end

end


