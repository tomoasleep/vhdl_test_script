module VhdlTestScript::DSL
  class StepBlock
    attr_reader :assign_ports, :before_assert_ports, :after_assert_ports, :testports
    def initialize(testports)
      @testports = testports
    end

    def assign(*ups)
      @assign_ports = ups
    end

    def before_assert(*ups)
      @before_assert_ports = ups
    end

    def after_assert(*ups)
      @after_assert_ports = ups
    end

    def _
      :dont_assign
    end
  end
end
