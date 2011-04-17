module Agent
  module Platform

    class PlatformControl 

      def initialize(platform)
        @platform = platform
      end

      def state
        @platform.state 
      end

    end

  end
end
