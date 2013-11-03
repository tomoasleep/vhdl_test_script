module VhdlTestScript
  class PortShadow < Port
    attr_reader :origin
    def initialize(origin, direction: nil, type: nil, name: nil, can_assign: nil)
      @origin = origin
      @name = name
      @type = type
      @direction = direction
      @can_assign = can_assign
    end

    def name
      @name || origin.name
    end

    def type
      @type || origin.type
    end

    def origin
      @origin.origin
    end

    private
    def direction
      @direction || origin.direction
    end
  end
end
