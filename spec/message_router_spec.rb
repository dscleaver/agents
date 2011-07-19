require 'spec_helper'

describe Agent::Platform::MessageRouter do

  describe "when stopped" do
    
    it "router is not running" do
      subject.running?.should == false
    end

    it "raises an error on calls to add" do
      lambda { subject.add("anything") }.should raise_error
    end

    it "raises an error on calls to contains" do
      lambda { subject.contains?("anything") }.should raise_error
    end

    it "raises an error on calls to remove" do
      lambda { subject.remove("anything") }.should raise_error
    end
  end

  describe "when started" do

    before(:all) do
      subject.start
    end 

    it "router is running" do
      subject.running?.should == true
    end

    it "raises error if start is called again" do
      lambda { subject.start }.should raise_error
    end

    it "contains no agents" do
      subject.contains?("Agent").should == false
    end

    it "route to an unknown agent raises an error" do
      lambda { subject.route("Agent", "message") }.should raise_error
    end

    describe "when an agent registers" do
      
      before(:each) do
        @agent_mock = double('Agent')
        @agent_mock.stub(:name).and_return('Agent')
        subject.add(@agent_mock)
      end

      it "agent is registered" do
        subject.contains?("Agent").should == true
      end

      it "send routes messages to agent" do
        @agent_mock.should_receive(:receive).with("message")
        subject.route("Agent", "message")
      end

      describe "when the agent is removed" do

        before(:each) do
          subject.remove(@agent_mock)
        end

        it "agent is not registered" do
          subject.contains?("Agent").should == false
        end
      end

    end

    describe "when stopped" do

      before(:all) do
        subject.stop
      end
      
      it "router is not running" do
        subject.running?.should == false
      end

    end

  end

end
