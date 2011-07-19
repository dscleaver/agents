require 'revactor'

module Agent

  class Agent
 
    def initialize(config)
      @config = config
    end

    def name
      @config.name
    end

    def receive(message)
    end

    def start(platform)
      init_actor = Actor.current
      Actor.spawn_link {
        run_agent(init_actor, platform)
      }
      Actor.receive { |filter| filter.when(:done) {} }
    end

    def run_agent(init_actor, platform)
        platform.messaging.add(self)
        @config.start_block.call(self)
        init_actor << :done 
    end

  end

end
