module VhdlTestScript
  class ScenarioDescription
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

    def ports(*ports)
      assign_port_shortcuts(*ports)
    end

    def generics(generics)
      generics.map { |g, v| @scenario.assign_generic(g, v) }
    end

    def clock(port)
      @scenario.set_clock(find_port(port))
    end

    def context(name = nil, &block)
      sub_desc = sub_scenario(name, &block)
    end

    def step(*cases, &block)
      if block
        step_block(&block)
      else
        @scenario.steps << gen_step(cases)
      end
    end

    def dependencies(*pathes)
      @scenario.load_dependencies(pathes)
    end

    def use_mock(name)
      @scenario.use_mock(name)
    end

    def use_mocks(*names)
      names.map { |name| use_mock(name) }
    end

    def wait_step(length)
      @scenario.steps << Wait.new(length)
    end

    def wait_for(length)
      @scenario.steps << Wait.new(length)
    end

    def z
      HighImpedance.new
    end

    def _
      :dont_assign
    end

    protected
    def port_shortcuts
      if @port_shortcuts
        @port_shortcuts
      elsif @parent_context
        @parent_context.port_shortcuts
      else
        nil
      end
    end

    private
    def step_block(&block)
      step_block_parser = DSL::StepBlock.new(@testports)
      step_block_parser.instance_eval &block
      @scenario.steps << analyze_block_step(step_block_parser)
    end

    def analyze_block_step(step_block_parser)
      pa = step_block_parser
      step_ports = [pa.assign_ports, pa.assert_ports_before, pa.assert_ports_after].
        map { |m| parse_step_arguments(m) }
      TestStep.new(*step_ports, nil, name)
    end

    def sub_scenario(child_name, &proc)
      subsc = ScenarioDescription.new(@scenario, self, child_name)
      @contexts << subsc
      subsc.instance_exec &proc
    end

    def assign_port_shortcuts(*ports)
      @port_shortcuts = ports.map { |i| find_port(i) }
    end

    def find_port(port)
      return port if port.is_a? Port
      @scenario.port_by_name(port)
    end

    def gen_step(cases)
      assignments = parse_step_arguments(cases)
      TestStep.new(
        *TestStep.divide_by_direction(assignments), nil, name
      )
    end

    def parse_step_arguments(args)
      args.each_with_index.reduce({}) do |result, (arg, idx)|
        case arg
        when Hash
          result.merge remove_dont_assign(
            (Hash[arg.map { |k, v| [find_port(k), v]}]))
        else
          result.merge remove_dont_assign(
            {port_shortcuts[idx] => arg})
        end
      end
    end

    def remove_dont_assign(hash)
      Hash[hash.select{|_,v| v != :dont_assign}]
    end
  end
end
