module Agent

  class Message

    def initialize(performative, fields)
      @fields = fields.merge({ :performative => performative })
    end

    def [](field)
      @fields[field]
    end

    def has_field?(field)
      @fields.has_key?(field)
    end

    def build_response(performative, fields)
      new_fields = @fields.merge( :sender => @fields[:receiver], :receiver => @fields[:sender] )
      if @fields.has_key? :reply_with
        new_fields[:in_reply_to] = new_fields.delete(:reply_with)
      end
      Message.new(performative, new_fields.merge(fields))
    end

  end

end
