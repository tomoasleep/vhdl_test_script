module VhdlTestScript
  class Value
    def self.gen(value, type = nil)
      case value
      when :high_impedance
        HighImpedance.new(type)
      else
        Value.new(value, type)
      end
    end

    attr_reader :value, :type
    def initialize(value, type = nil)
      @value = value
      @type = type
    end

    def type_is?(type)
      @type == type
    end

    def format(type = @type)
      type.origin_type.format(@value)
    end

    def to_s
      value.to_s
    end
  end
end
