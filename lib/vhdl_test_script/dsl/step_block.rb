module VhdlTestScript::DSL
  class StepBlock
    attr_reader :assign_ports, :assert_ports_before, :assert_ports_after, :testports
    def initialize(testports)
      @testports = testports
    end

    def assign(*ups)
      @assign_ports = ups
    end

    def assert_before(*ups)
      @assert_ports_before = ups
    end

    def assert_after(*ups)
      @assert_ports_after = ups
    end

    def _
      :dont_assign
    end
  end
end
