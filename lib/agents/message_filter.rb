module Agent

  class MessageFilter
  
    def initialize(performative, fields)
      @fields = fields.merge(:performative => performative)
    end

    def ===(object)
      if not object.kind_of?(Message)
        return false
      end

      for key in @fields.keys
        if not match_in_object(key, object)
          return false
        end
      end
      
      return true
    end

    private
 
    def match_in_object(key, object)
      @fields[key] === object[key]
    end

  end

end
