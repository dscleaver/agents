require 'spec_helper'

#require 'revactor'

describe "Platform" do

  describe "created without block" do

    it "raises an error" do
      lambda { Agent::Platform::create }.should raise_error
    end
  end

  describe "created without agents" do
    it "will exit immediately" do
      platform = Agent::Platform::create { }
      platform.state.should == :stopped
    end
  end

  describe "with one agent" do

    before(:all) do
      actor = Actor.current
      @platform = Agent::Platform::create do
        agent "Agent" do 
          on_start do
            actor = Actor.current
          end
        end
      end
      @actor = actor
    end

    it "platform should be running" do
      @platform.state.should == :running
    end

    it "agent starts in a new actor" do
      @actor.should_not == Actor.current
    end

  end
end
