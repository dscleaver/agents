require 'spec_helper'

#require 'revactor'

describe "Agent::Platform" do

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
      ag = :nil
      @platform = Agent::Platform::create do
        agent "Agent" do 
          on_start do |agent|
            actor = Actor.current
            ag = agent
          end
        end
      end
      @actor = actor
      @agent = ag
    end

    it "platform should be running" do
      @platform.state.should == :running
    end

    it "agent starts in a new actor" do
      @actor.should_not == Actor.current
    end

    it "agent registers with message router" do
      @platform.messaging.contains?("Agent").should == true
    end
   
  end
end
