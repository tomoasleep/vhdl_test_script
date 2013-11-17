module VhdlTestScript
  class NoEntityError < NameError
  end

  class Scenario
    def self.describe(*all_args, &scenario_block)
      dut_path, *args = *all_args
      tags = parse_args(args)
      Scenario.new(dut_path, VhdlTestScript.world.current_test_path, tags: tags, &scenario_block)
    end

    def self.world
      VhdlTestScript.world
    end

    attr_accessor :steps
    attr_reader :example, :package_names, :dut, :generic_assigns, :output, :description, :tags
    def initialize(dut_path, test_path, options = {}, &scenario_block)
      @test_path = test_path
      @dut_path = File.expand_path(dut_path, File.dirname(@test_path))
      @scenario_block = scenario_block
      @mocks = {}; @entities = []; @steps = []; @package_names = []; @generic_assigns = {};
      @dependencies = []; @dependencies_pathes = []; @dummy_entities = {};

      parse_options(options)
      load_dut(@dut_path)
      @testbench = TestBench.new(@dut, self)
    end

    def parse_options(options)
      @tags = []
      options.each do |k, v|
        case k
        when :tags
          @tags += v
        end
      end
    end

    def actors
      [@testbench, *@mocks.values]
    end

    def load_dependencies(files)
      abs_pathes = files.map { |f| File.expand_path(f, File.dirname(@test_path))}
      files =  abs_pathes.map { |f| Dir[f] }.flatten
      newfiles = (files - @dependencies_pathes - [@dut_path])
      newdps = newfiles.map do |f|
        VhdlParser.read(f)
      end
      @dependencies += newdps
      @dependencies_pathes += newfiles

      packages_scan(newdps)
    end

    def load_dut(path)
      parser = VhdlParser.read(path)
      @dut = parser.entity

      packages_scan([parser])
    end

    def tmpdir
      require 'tmpdir'
      @tmpdir ||= Dir.mktmpdir
    end

    def assign_generic(generic, value)
      case generic
      when Generic
        @generic_assigns[generic] = value
      else
        generic_name = generic.to_s
        generic_by_name = @dut.generics.find {|g| g.name == generic_name }
        @generic_assigns[generic_by_name] = value
      end
    end

    def run(options = {})
      parse_description
      create_test_files
      report_output_header
      run_test
      report_output if options[:verbose]
      self
    end

    def report
      report_result
      self
    end

    def use_mock(entity_name)
      original_entity = @dut.components.find { |c| c.name == entity_name.to_s }
      if !original_entity
        raise NoEntityError
      elsif !@mocks[original_entity.name]
        @mocks[original_entity.name] = (mock = Mock.new(original_entity, self))
        @dummy_entities[original_entity.name] = VhdlTestScript::DSL::DummyEntity.new(mock.entity)
      else
        @dummy_entities[original_entity.name]
      end
    end

    def entities
      [@dut, *@mocks.map(&:entity)]
    end

    def find_port(key)
      if key.kind_of? VhdlTestScript::Port
        key
      else
        port_by_name(key)
      end
    end

    def set_clock(port)
      target_actor = actors.find { |actor| actor.entity.ports.member?(port) }
      target_actor.clock = port
    end

    def port_by_name(name)
      entities.each do |entity|
        res = entity.ports.find { |port| port.name.to_sym == name.to_sym }
        return res if res
      end
      raise "port #{name} is not exist in [#{entities.map(&:name).join(", ")}]"
    end

    def packages_scan(parsers)
      parsers.each do |parser|
        parser.packages.each do |package|
          @package_names << package.name
          package.constants.each { |name, type| Scenario.world.register_const_type(name, type) }
          package.subtypes.each { |name, type| Scenario.world.register_subtype(name, type) }
        end
      end
    end

    def parse_description
      @description ||= ScenarioDescription.parse(self, &@scenario_block)
      self
    end

    def create_test_files
      test_bench_file, *mock_files =
        [@testbench, *@mocks.map {|k,m| m}].map { |actor| actor.test_file.create(tmpdir)}
      pathes = @dependencies_pathes + mock_files.map(&:path)
      @runner_script =
        RunnerScript.new(tmpdir, pathes, @dut_path, test_bench_file.path, test_bench_file.unitname)
    end

    def result
      @result_formatter
    end

    private
    def self.parse_args(args)
      tags = args.reduce([]) do |result, arg|
        case arg
        when Symbol
          result << arg
        end
      end
    end

    def run_test
      @output = @runner_script.run
      @result_formatter = Result.parse(self, @output)
    end

    def report_output_header
      Scenario.world.reporter.report_test_header(@dut.name, tmpdir)
    end

    def report_output
      Scenario.world.reporter.output(@output)
    end

    def report_result
      Scenario.world.reporter.report_results(self)
    end
  end
end
