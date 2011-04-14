require 'spec_helper'

describe PetriNet do

  describe "after initialization" do
    it "has no places," do
      subject.total_places.should == 0
    end

    it "no transitions," do
      subject.total_transitions.should == 0
    end

    it "no places with tokens," do
      subject.filled_places.should be_empty
    end

    it "and no active transitions" do
    end
  end

  describe "when adding a Place" do

    before(:all) do
      @id = subject.add_place
    end

    it "should have one place" do
      subject.total_places.should == 1
    end

    it "return an assigned id" do
      "P-1".should === @id
    end
  end

end
