module VhdlTestScript
  class ScenarioDescription
    include VhdlTestScript::DSL
    def self.parse(scenario, &scenario_block)
      desc = new(scenario)
      dut_dummy = VhdlTestScript::DSL::DummyEntity.new(scenario.dut)
      desc.instance_exec(dut_dummy, &scenario_block)
      desc
    end

    def initialize(scenario)
      @scenario = scenario
    end
  end
end
