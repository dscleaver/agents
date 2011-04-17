require 'revactor'

module Agent
  class AgentConfig

    attr_accessor :name, :start_block

    def initialize(name, &setup)
      @name = name

      instance_eval(&setup)
    end

    def on_start(&block)
      @start_block = block
    end

  end
end
