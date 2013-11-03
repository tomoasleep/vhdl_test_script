module VhdlTestScript
  class HighImpedance < Value
    attr_reader :type
    def initialize(type = nil)
      @type = type
    end

    def value
      type.all_assign("Z") if type
    end

    def format(type = @type)
      type.all_assign("Z")
    end

    def to_s
      "Z"
    end
  end
end
