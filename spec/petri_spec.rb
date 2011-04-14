require 'spec_helper'

describe PetriNet, " after initialization" do

  it "has no places" do
    subject.total_places.should == 0
  end

  it "and no transitions" do
    subject.total_transitions.should == 0
  end

end
