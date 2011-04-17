module PetriNet

  class PetriNet

    attr_accessor :filled_places, :active_transitions

    def initialize
      @filled_places = []
      @active_transitions = []
      @transitions = {}
      @places = {}
    end
  
    def total_places
      @places.length
    end

    def total_transitions
      @transitions.length
    end

    def add_place
      id = PlaceId.new(total_places + 1) 
      @places[id] = Place.new(id)
      return id
    end

    def add_transition(inputs, t, outputs)
      if inputs.length == 0 
        raise "every transition must have at least one input place"
      end
      input_places = inputs.map { |input| @places[input] }
      transition = Transition.new(input_places, t, outputs)
      @transitions[t] = transition 
      input_places.map { |place| place.add_transition(transition) }
    end

    def place_token(pid, token)
      if not @filled_places.include? pid
        @filled_places << pid
      end
      place = @places[pid]
      place << token
      for transition in place.transitions
        if transition.active? and not @active_transitions.include? transition.object
          @active_transitions << transition.object
        end
      end 
    end

    def choose_transition(transition)
      #@active_transitions.reject! {|item| item == transition}
      @transitions[transition].inputs.map do |p| 
        token = p.pop
        if p.tokens == 0
          @filled_places.delete(p.id)
          for t in p.transitions
            @active_transitions.delete(t.object)
          end
        end
        token
      end
    end

    def outputs_for(transition)
      @transitions[transition].outputs
    end

  end

  class Transition
  
    attr_accessor :inputs, :object, :outputs

    def initialize(inputs, object, outputs)
      @inputs = inputs
      @object = object
      @outputs = outputs
    end

    def active?
      for place in inputs
        if place.tokens == 0
          return false
        end
      end
      return true
    end

  end
 
  class Place 

    attr_accessor :id

    def initialize(id)
      @tokens = []
      @transitions = []
      @id = id
    end

    def <<(token)
      @tokens.insert(0, token)
    end

    def pop
      @tokens.pop
    end

    def tokens
      @tokens.length
    end
 
    def add_transition(transition)
      @transitions << transition
    end

    def transitions
      @transitions
    end

  end

  class PlaceId

    def initialize(counter)
      @counter = counter
    end

    def to_s
      return "P-" + @counter.to_s
    end

    def hash
      @counter
    end

    def eql?(place)
      @counter == place.instance_variable_get(:@counter)
    end

    def ==(place)
      eql?(place)
    end
  end
end
