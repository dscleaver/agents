require 'revactor'

module Agent

  class Agent
    
    def initialize(config)
      @config = config
    end

    def start
      init_actor = Actor.current
      Actor.spawn_link {
        run_agent(init_actor)
      }
      Actor.receive { |filter| filter.when(:done) {} }
    end

    def run_agent(init_actor)
        @config.start_block.call(self)
        init_actor << :done 
    end

  end

end
