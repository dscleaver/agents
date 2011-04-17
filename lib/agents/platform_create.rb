lib = File.dirname(__FILE__)

require lib + '/platform'
require lib + '/platform_control'

module Agent
  module Platform

    def self.create(&block)
      platform = Platform.new(&block)
      platform.start()
      PlatformControl.new(platform)
    end

  end
end 
