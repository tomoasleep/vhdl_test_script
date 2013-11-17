module VhdlTestScript
  class ScenarioDescription
    include VhdlTestScript::DSL
    def self.parse(scenario, &scenario_block)
      desc = new(scenario)
      dut_dummy = VhdlTestScript::DSL::DummyEntity.new(scenario.dut)
      desc.instance_exec(dut_dummy, &scenario_block)
      desc
    end

    attr_reader :basename, :contexts
    def initialize(scenario, parent_context = nil, basename = nil)
      @parent_context = parent_context
      @basename = basename
      @scenario = scenario
      @contexts = []

      inherit_parent_context if @parent_context
    end

    def name
     name_path.compact.join(" ")
    end

    def name_path
      if @parent_context
        [*@parent_context.name_path, @basename]
      else
        [@basename]
      end
    end

    protected
    def testports
      @testports
    end

    def sub_scenario(child_name, &proc)
      subsc = ScenarioDescription.new(@scenario, self, child_name)
      @contexts << subsc
      subsc.instance_exec &proc
    end

    def inherit_parent_context
      return unless @parent_context
      @testports = @parent_context.testports
    end

    def assign_test_ports(*names)
      @testports = names.map do |i|
        @scenario.find_port(i)
      end
    end
  end
end
