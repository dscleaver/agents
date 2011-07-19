lib = File.dirname(__FILE__)

require lib + '/platform_config'
require lib + '/platform_message_router'
require lib + '/agent'
require 'revactor'

module Agent
  module Platform 

    class Platform    

      attr_accessor :state, :messaging

      def initialize(&block)
        @state = :configuring
        @config = PlatformConfig.new(&block) 
      end

      def start
        if @config.agents.empty?
          @state = :stopped
          return
        end

        setup

        @state = :running
      end

      private

      def setup
        setup_support_services
        setup_agents
      end

      def setup_support_services
        @messaging = MessageRouter.new
        @messaging.start
      end

      def setup_agents
        for config in @config.agents
          agent = ::Agent::Agent.new(config)
          agent.start(self)
        end
      end

    end

  end

end
