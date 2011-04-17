lib = File.dirname(__FILE__)

require lib + '/agent_config'

module Agent
  module Platform
    
    class PlatformConfig

      attr_accessor :agents

      def initialize(&setup)
        @agents = []
        instance_eval(&setup)
      end

      def agent(name, &setup)
        @agents << ::Agent::AgentConfig.new(name, &setup)
      end

    end

  end
end
