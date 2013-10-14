module VhdlDoctest
  class Port
    attr_reader :name

    def initialize(name, direction, type)
      @name, @direction, @type = name, direction, type
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
      case value 
      when :rising_edge
        [@type.min_value, @type.max_value].map {|v| "#@name <= #{@type.format(v)};"}.join("\nwait for 1 ns;\n")
      else
        "#@name <= #{@type.format(value)};"
      end
    end

    def equation(value)
      "#@name = #{@type.format(value)}"
    end

    def in?
      @direction == :in
    end
  end
end
