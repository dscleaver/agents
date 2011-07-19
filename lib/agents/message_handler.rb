lib = File.dirname(__FILE__)

require lib + '/message_filter'
require lib + '/actor_object'
require 'revactor'

module Agent

  class MessageHandler

    include ::Utilities::ActorObject

    def initialize(message_router)
      @message_router = message_router
    end

    def add_conversation(conversation_id, actor)
      only_if_running do
        @actor << [:add, conversation_id, actor, Actor.current]
        Actor.receive { |filter| filter.when([:done, self]) { }}
      end
    end

    def remove_conversation(conversation_id)
      only_if_running do
        @actor << [:remove, conversation_id, Actor.current]
        Actor.receive { |filter| filter.when([:done, self]) {}}
      end
    end

    def handle(message) 
      only_if_running do
        @actor << message
      end
    end

    private

    def init_state
      {}
    end

    def step(conversations)
      receive do |filter|
        filter.when(Case[:add, Object, Object, Object]) do |_, conversation_id, handler, actor|
          conversations[conversation_id] = handler
          actor << [:done, self]
        end
        filter.when(Case[:remove, Object, Object]) do |_, conversation_id, actor|
          conversations.delete(conversation_id)
          actor << [:done, self]
        end

        for key in conversations.keys
          filter.when(MessageFilter.new(Object, :conversation_id => key)) { |msg| conversations[key] << msg }
        end

        filter.when(MessageFilter.new(:not_understood, {})) { }

        filter.when(MessageFilter.new(Object, { :sender => Object })) { |msg| send_default_response(msg) }
      end
    end

    def send_default_response(message)
      @message_router.route(message[:sender], message.build_response(:not_understood, { :content => message }))
    end

  end

end
