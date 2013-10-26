module VhdlTestScript
  class Port
    attr_reader :name

    def initialize(name, direction, type, can_assign = nil)
      @name, @direction, @type = name, direction, type
      @can_assign = if can_assign.nil? then in? else can_assign end
    end

    def port_definition
      "#@name : #@direction #{@type.to_vhdl}"
    end

    def signal_definition
      "signal #@name : #{@type.to_vhdl};"
    end

    def mapping
      "#@name => #@name"
    end

    def assignment(value)
      "#@name <= #{@type.format(value)};"
    end

    def assignment_min
      "#@name <= #{@type.format(@type.min_value)};"
    end

    def assignment_max
      "#@name <= #{@type.format(@type.max_value)};"
    end

    def equation(value)
      "#@name = #{@type.format(value)}"
    end

    def in?
      @direction == :in
    end

    def can_assign?
      @can_assign
    end

    def assign_abilities_reverse
      Port.new(@name, @direction, @type, !@can_assign)
    end
  end
end
