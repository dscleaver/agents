class PetriNet

  attr_accessor :total_places, :total_transitions

  def initialize
    @total_places = 0
    @total_transitions = 0
  end

  def filled_places 
    []
  end

  def active_transitions
    []
  end

  def add_place
    @total_places = @total_places + 1
    return "P-" + @total_places.to_s
  end

end
