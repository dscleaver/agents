require 'spec_helper'

class MockMessageRouter

  attr_accessor :receiver, :message, :calls

  def initialize(actor)
    @actor = actor
    @calls = 0
  end

  def route(receiver, message)
    @calls = @calls + 1
    @receiver = receiver
    @message = message
    @actor << :done
  end

  def reset
    @calls = 0
    @receiver = nil
    @message = nil
  end

  def wait
    Actor.receive { |filter| filter.when(:done) {}}
  end

end


describe Agent::MessageHandler do

  subject { @message_router = MockMessageRouter.new(Actor.current); Agent::MessageHandler.new(@message_router) }

  it "not running" do
    subject.running?.should == false
  end

  it "errors when add_conversation is called" do
    lambda { subject.add_conversation(:conversation_id, Actor.current) }.should raise_error
  end

  it "errors when remove_conversation is called" do
    lambda { subject.remove_conversation(:conversation_id) }.should raise_error
  end

  it "errors when handle is called" do
    lambda { subject.handle("message") }.should raise_error
  end 

  describe "when started" do

    before(:all) do
      subject.start
    end
  
    before(:each) do
      @message_router.reset
    end


    it "is running" do
      subject.running?.should == true
    end

    it "sends not-understood to sender when no conversation matches" do
      subject.handle(Agent::Message.new(:request, { :sender => "Agent" }))

      @message_router.wait
      @message_router.calls.should == 1
      @message_router.receiver.should == "Agent"
      @message_router.message[:performative].should == :not_understood
      @message_router.message[:receiver].should == "Agent"
    end

    it "does not send not-understood in response to a not-understood" do
      subject.handle(Agent::Message.new(:not_understood, {:sender => "Agent"}))
      
      @message_router.calls.should == 0
    end

    describe "when a conversation is registered" do
   
      before(:all) do
        subject.add_conversation("conversation id", Actor.current)
      end
 
      it "the registered actor should receive messages to conversation" do
        sent = Agent::Message.new(:request, :conversation_id => "conversation id")
        subject.handle(sent)

        message = nil
        Actor.receive { |filter| filter.when(Agent::MessageFilter.new(:request, {})) { |msg| message = msg }}
 
        message.should == sent 
      end

      describe "when the conversation is removed" do
        
        before(:all) do
          subject.remove_conversation("conversation id")
        end

        it "sends not-understood in response to messages on that conversation" do
          subject.handle(Agent::Message.new(:request, :sender => "Agent", :conversation_id => "conversation id"))
         
          @message_router.wait
          @message_router.calls.should == 1
        end

      end

    end

    describe "when stopped" do

      before(:all) do
        subject.stop
      end
      
      it "handler is not running" do
        subject.running?.should == false
      end

    end


  end

end
