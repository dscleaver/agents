lib = File.dirname(__FILE__)
require 'revactor'
require lib + '/actor_object'

module Agent
  module Platform
    class MessageRouter
      include ::Utilities::ActorObject      

      def contains?(name)
        only_if_running do
          @actor << [:contains, name, Actor.current]
          result = false
          Actor.receive { |filter| filter.when(Case[ self, :contains, Object ]) { |_,_,value| result = value } }
          result
        end
      end

      def add(agent)
        only_if_running do
          @actor << [:add, agent, Actor.current]
          Actor.receive { |filter| filter.when([self, :done]) { }}
        end
      end

      def remove(agent)
        only_if_running do
          @actor << [:remove, agent, Actor.current]
          Actor.receive { |filter| filter.when([self, :done]) { }}
        end
      end

      def route(name, message)
        success = false
        @actor << [:route, name, message, Actor.current]
        Actor.receive { |filter| filter.when(Case[self, Object]) { |_, result| success = result } }
        if not success
          raise "Agent " + name + " not found!"
        end
      end

      private

      def init_state
        {}
      end

      def step(registry)
        receive do |filter|
          filter.when(Case[:add, Object, Object]) do |_, agent, actor|
            registry[agent.name] = agent
            actor << [self, :done]
          end
          filter.when(Case[:remove, Object, Object]) do |_, agent, actor|
            registry.delete(agent.name)
            actor << [self, :done]
          end
          filter.when(Case[:contains, Object, Object]) do |_, name, actor|
            actor << [ self, :contains, registry.has_key?(name)]
          end
          filter.when(Case[:route, Object, Object, Object]) do |_, name, message, actor|
            has_agent = registry.has_key?(name)
            actor << [self, has_agent]
            if has_agent
              registry[name].receive(message)
            end
          end
        end
      end

    end
  end
end
