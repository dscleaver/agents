require 'spec_helper'

describe Agent::Message do

  it "constructing with only a performative raises exception" do
    lambda { Agent::Message.new(:request) }.should raise_exception
  end

  describe "when properly constructed" do

    subject { Agent::Message.new(:request, :receiver => "Agent", :content => "Content") }

    it "exposes performative as a field" do
      subject[:performative].should == :request
    end

    it "exposes all passed in fields" do
      subject[:receiver].should == "Agent"
      subject[:content].should == "Content"
    end

    it "fields that are not set return nil" do
      subject[:in_reply_to].should == nil
    end

    it "has field if field set" do
      subject.has_field?(:performative).should == true
    end

    it "does not have field if not set" do
      subject.has_field?(:in_reply_to).should == false
    end

    describe "when building a response" do

      it "adds all fields provided to the response" do
        message = Agent::Message.new(:request, {})
        
        response = message.build_response(:inform, :content => "result")

        response[:performative].should == :inform
        response[:content].should == "result"
      end

      it "swaps sender and receiver" do
        message = Agent::Message.new(:request, :sender => "Sender", :receiver => "Receiver")

        response = message.build_response(:inform, {})

        response[:sender].should == "Receiver"
        response[:receiver].should == "Sender"
      end

      it "changes reply_with into in_reply_to" do
        message = Agent::Message.new(:request, :reply_with => "reply")

        response = message.build_response(:inform, {})
  
        response[:in_reply_to].should == "reply"
        response.has_field?(:reply_with).should == false
      end

      it "does not add in_reply_to if no reply_with is provided" do
        message = Agent::Message.new(:request, {})

        message.build_response(:inform, {}).has_field?(:in_reply_to).should == false
      end

    end

  end

end
