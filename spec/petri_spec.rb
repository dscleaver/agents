require 'spec_helper'

describe PetriNet::PetriNet do

  describe "after initialization" do
    it "has no places" do
      subject.total_places.should == 0
    end

    it "has no transitions" do
      subject.total_transitions.should == 0
    end

    it "has no places with tokens" do
      subject.filled_places.should be_empty
    end

  end

  describe "when adding a Place" do

    before(:all) do
      @id = subject.add_place
    end

    it "has one place" do
      subject.total_places.should == 1
    end

    it "returns an assigned id" do
      PetriNet::PlaceId.new(1).should === @id
    end
  end

  describe "adding a Transition with no input places" do
    
    it "raises an error" do
      lambda {subject.add_transition([], "", [])}.should raise_error
    end

  end

  describe "with structure p1->t->p2" do
  
    before(:all) do
      @p1 = subject.add_place
      @p2 = subject.add_place
      @t = ""
      subject.add_transition([@p1], @t, [@p2])
    end

    it "has one transition" do
      subject.total_transitions.should == 1
    end

    it "has two places" do
      subject.total_places.should == 2
    end

    it "returns output places" do
      subject.outputs_for(@t).should === [@p2]
    end

    describe "when a token is placed on p1" do
      
      before(:all) do
        @token = "Token"
        subject.place_token(@p1, @token)
      end

      it "active transitions contains t" do
        subject.active_transitions.should === [@t]
      end

      it "filled places contains p1" do
        subject.filled_places.should === [@p1]
      end

      describe "when t is pending" do

        before(:all) do
          @toks = subject.choose_transition(@t)
        end

        it "t is no longer in the active transitions" do
          subject.active_transitions.should be_empty
        end

        it "p1 is not in filled places" do
          subject.filled_places.should be_empty
        end

        it "returns array containing token from p1" do
          @toks.should === [@token]
        end

      end
    end
  end

  describe "with structure p1p2->t->p3p4" do

    before(:all) do
      @p1 = subject.add_place
      @p2 = subject.add_place
      @p3 = subject.add_place
      @p4 = subject.add_place
      @t = "Transition"
      subject.add_transition([@p1, @p2], @t, [@p3, @p4])
    end

    it "returns p3 and p4 as outputs" do
      subject.outputs_for(@t).should === [@p3, @p4]
    end

    describe "when two tokens are placed on p1" do

      before(:all) do
        @token1 = "Token 1"
        @token3 = "Token 3"
        subject.place_token(@p1, @token1)
        subject.place_token(@p1, @token3)
      end

      it "t will not be in active transitions" do
        subject.active_transitions.should be_empty
      end

      it "should only be in filled list once" do
        subject.filled_places.should === [@p1]
      end
 
      describe "when a token is placed on p2" do

        before(:all) do
          @token2 = "Token 2"
          subject.place_token(@p2, @token2)
        end

        it "t will be in active transitions" do
          subject.active_transitions.should === [@t]
        end

        describe "when t is chosen" do

          before(:all) do
            @toks = subject.choose_transition(@t)
          end

          it "returns tokens from p1 and p2" do
            @toks.should === [@token1, @token2]
          end

          it "p1 still in filled places" do
            subject.filled_places.should === [@p1]
          end
        end
      end
    end
  end

  describe "with structure p1->t1t2->p2" do
 
   before(:all) do
     @p1 = subject.add_place
     @p2 = subject.add_place
     @t1 = "Transition 1"
     @t2 = "Transition 2"
     subject.add_transition([@p1], @t1, [@p2])
     subject.add_transition([@p1], @t2, [@p2])
   end

   describe "when token placed in p1" do
     
     before(:all) do
       @token1 = "Token 1"
       subject.place_token(@p1, @token1)
     end

     it "t1 and t2 in active transitions" do
       subject.active_transitions.should === [@t1, @t2]
     end

     describe "when t2 is chosen" do

       before(:all) do
         subject.choose_transition @t2
       end

       it "active transitions empty" do
         subject.active_transitions.should be_empty
       end

     end

   end

   describe "when two tokens are placed in p1" do
     
     before(:all) do
       @token1 = "Token 1"
       @token2 = "Token 2"
       subject.place_token(@p1, @token1)
       subject.place_token(@p1, @token2)
     end

     it "t1 and t2 in active transitions" do
       subject.active_transitions.should === [@t1, @t2]
     end
 
     describe "when t1 is chosen" do
     
       it "t1 and t2 in active transitions" do
         subject.active_transitions.should === [@t1, @t2]
       end

     end 
 
   end
  end

end
