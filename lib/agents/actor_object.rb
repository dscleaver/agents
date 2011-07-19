require 'revactor'

module Utilities
  
  module ActorObject
    
    def start
      if running?
        raise "Already running"
      end
      @actor = Actor.spawn { run }
    end

    def running?
      if @actor
        return true
      end
      false
    end

    def stop
      @actor << [:stop, Actor.current]
      Actor.receive { |filter| filter.when([:stopped, self]) { }}
    end

    def only_if_running
      if running?
        yield
      else
        raise "Message Router is not running"
      end
    end

    protected
 
    def receive(&block)
      Actor.receive do |filter|
        filter.when(Case[:stop, Object]) do |_, actor|
          @done = true
          actor << [:stopped, self]
        end
        block.call filter
      end
    end

    private

    def run
      @done = false
      state = init_state
      while not @done
        step state
      end
      @actor = nil
    end
  
  end

end
