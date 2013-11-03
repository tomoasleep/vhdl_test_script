require "vhdl_test_script/dsl/dummy_entity"
require "vhdl_test_script/dsl/step_block"

module VhdlTestScript
  module DSL
    def self.port_by_name(ports, name)
      ports.find {|p| p.name.to_sym == name.to_sym}
    end

    def ports(*ports)
      assign_test_ports(*ports)
    end

    def generics(generics)
      generics.map { |g, v| @scenario.assign_generic(g, v) }
    end

    def clock(port)
      @scenario.set_clock(@scenario.find_port(port))
    end

    def step(*ups, &block)
      if block
        step_block(&block)
      else
        @scenario.steps << gen_step(ups)
      end
    end

    def wait_step(length)
      @scenario.steps << VhdlTestScript::Wait.new(length)
    end

    def dependencies(*pathes)
      @scenario.load_dependencies(pathes)
    end

    def use_mock(name)
      use_mocks(name).first
    end

    def use_mocks(*names)
      names.map do |name|
        @scenario.use_mock(name)
      end
    end

    def z
      HighImpedance.new
    end

    def _
      :dont_assign
    end

    private
    def assign_test_ports(*names)
      @testports = names.map do |i|
        @scenario.find_port(i)
      end
    end

    def step_block(&block)
      step_block_parser = StepBlock.new(@testports)
      step_block_parser.instance_eval &block
      @scenario.steps << analyze_block_step(step_block_parser)
    end

    def gen_step(ups)
      assignments = parse_step_arguments(ups)
      TestStep.new(
        *TestStep.divide_by_direction(assignments)
      )
    end

    def analyze_block_step(step_block_parser)
      pa = step_block_parser
      step_ports = [pa.assign_ports, pa.assert_ports_before, pa.assert_ports_after].
        map { |m| parse_step_arguments(m, pa.testports) }
      TestStep.new(*step_ports)
    end

    def parse_step_arguments(ups, testports = @testports)
      return {} if ups.empty?
      case ups.first
      when Hash
        assignments = remove_not_assign(
          (Hash[ups.first.map { |k, v| [@scenario.find_port(k), v]}]))
      else
        assignments = remove_not_assign(Hash[testports.zip(ups)])
      end
    end

    def remove_not_assign(hash)
      Hash[hash.select{|_,v| v != :dont_assign}]
    end
  end
end
