require 'spec_helper'

describe Agent::MessageFilter do

  it "does not match non messages" do
    filter = Agent::MessageFilter.new(:request, {})

    filter.should_not === "some string"
  end

  describe "when only performative is provided" do

    it "matches a message with same performative" do
      filter = Agent::MessageFilter.new(:request, {})
   
      filter.should === Agent::Message.new(:request, {})
    end

    it "does not match a message with a different performative" do
      filter = Agent::MessageFilter.new(:request, {})
     
      filter.should_not === Agent::Message.new(:inform, {})
    end

    it "matches any performative if Object is provided in filter" do
      filter = Agent::MessageFilter.new(Object, {})

      filter.should === Agent::Message.new(:inform, {})
    end

    it "matches a message that contains other fields" do
      filter = Agent::MessageFilter.new(:request, {})
      
      filter.should === Agent::Message.new(:request, :content => "content")
    end 

  end

  describe "when multiple fields are provided" do

    it "does not match messages which do not contain all the fields" do
      filter = Agent::MessageFilter.new(:request, :conversation_id => "conversation", :receiver => "me")

      filter.should_not === Agent::Message.new(:request, :conversation_id => "conversation")    
    end

    it "does not match messages that don't have the right field values" do
      filter = Agent::MessageFilter.new(:request, :conversation_id => "conversation", :receiver => "me")

      filter.should_not === Agent::Message.new(:request, :conversation_id => "conversation", :receiver => "him")
    end

    it "matches messages that have all the right fields" do
      filter = Agent::MessageFilter.new(:request, :conversation_id => "conversation", :receiver => "me")

      filter.should === Agent::Message.new(:request, :conversation_id => "conversation", :receiver => "me")
    end

    it "matches message no matter the order that their fields initialize" do
      filter = Agent::MessageFilter.new(:request, :conversation_id => "conversation", :receiver => "me")

      filter.should === Agent::Message.new(:request, :receiver => "me", :conversation_id => "conversation")
    end

    it "matches messages with more fields than the filter has" do
      filter = Agent::MessageFilter.new(:request, :conversation_id => "conversation", :receiver => "me")

      filter.should === Agent::Message.new(:request, :receiver => "me", :conversation_id => "conversation", :reply_with => "value")
    end

    it "supports case style matching in the message" do
      filter = Agent::MessageFilter.new(:request, :conversation_id => Object)

      filter.should === Agent::Message.new(:request, :conversation_id => "conversation")
    end

  end

end
