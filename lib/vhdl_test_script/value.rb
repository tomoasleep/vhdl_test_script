module VhdlTestScript
  class Value
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
  end
end
