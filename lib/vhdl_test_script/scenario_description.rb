module VhdlTestScript
  class ScenarioDescription
    include VhdlTestScript::DSL
    def self.parse(scenario, &scenario_block)
      desc = new(scenario)
      dut_dummy = VhdlTestScript::DSL::DummyEntity.new(scenario.dut)
      desc.instance_exec(dut_dummy, &scenario_block)
      desc
    end

    attr_accessor :name
    def initialize(scenario)
      @scenario = scenario
    end

    def sub_scenario(name, &proc)
      subsc = ScenarioDescription.new(@scenario)
      subsc.name = name
      subsc.instance_exec &proc
    end
  end
end
