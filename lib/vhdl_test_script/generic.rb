module VhdlTestScript
  class Generic
    attr_reader :name

    def initialize(name, type, default = nil)
      @name, @type, @default = name, type, default
    end

    def generic_definition
      "#@name : #{@type.to_vhdl}#{default_definition}"
    end

    def mapping(value = @default)
      "#@name => #{@type.format(value)}"
    end

    private
    def default_definition
      @default ?  " := #{@type.format(@default)}" : ""
    end
  end
end
