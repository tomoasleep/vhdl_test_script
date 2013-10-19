module VhdlTestScript
  class ScenarioDescription
    include VhdlTestScript::DSL
    def self.parse(scenario, &scenario_block)
      desc = new(scenario)
      desc.instance_eval(&scenario_block)
      desc
    end

    def initialize(scenario)
      @scenario = scenario
    end
  end
end
