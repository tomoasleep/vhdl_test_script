module VhdlTestScript
  class Scenario
    def self.describe(*all_args, &scenario_block)
      dut_path, *args = *all_args
      Scenario.new(dut_path, VhdlTestScript.world.current_test_path, &scenario_block)
    end

    def self.world
      VhdlTestScript.world
    end

    attr_accessor :steps
    attr_reader :example, :package_names
    def initialize(dut_path, test_path, &scenario_block)
      @test_path = test_path
      @dut_path = File.expand_path(dut_path, File.dirname(@test_path))
      @scenario_block = scenario_block
      @mocks = {}; @entities = []; @steps = []; @package_names = [];
      @dependencies = []; @dependencies_pathes = [];

      load_dut(@dut_path)
      @testbench = TestBench.new(@dut, self)
    end

    def load_dependencies(files)
      files = files.map { |f| File.expand_path(f, File.dirname(@test_path))}
      newfiles = (files - @dependencies_pathes)
      newdps = newfiles.map do |f|
        VhdlParser.read(f)
      end
      @dependencies += newdps
      @dependencies_pathes += newfiles

      entity_scan(newdps)
      packages_scan(newdps)
    end

    def load_dut(path)
      parser = VhdlParser.read(path)
      @dut = parser.entity

      entity_scan([parser])
      packages_scan([parser])
    end

    def tmpdir
      require 'tmpdir'
      @tmpdir ||= Dir.mktmpdir
    end

    def run
      configure
      test_files =
        [@testbench, *@mocks.map {|k,m| m}].map { |actor| actor.test_file.create(tmpdir)}
      pathes = @dependencies_pathes + [@dut_path] + test_files.map(&:path)
      @runner_script =
        RunnerScript.new(tmpdir, pathes, test_files.first.unitname)
      Scenario.world.reporter.report_result(self, @runner_script.run)
    end

    def use_mock(entity_name)
      entity = entity_by_name(entity_name)
      @mocks[entity.name] = Mock.new(self, entity) if !@mocks[entity] && entity
    end

    def entity_by_name(name)
      @entities.find { |entity| entity.name == name }
    end

    def port_by_name(name)
      @entities.each do |entity|
        res = entity.ports.find { |port| port.name.to_sym == name.to_sym }
        return res if res
      end
      p @entities
      raise "port #{name} is not exist in [#{@entities.map(&:name).join(", ")}]"
    end

    def entity_scan(parsers)
      parsers.each do |parser|
        @entities << parser.entity if parser.have_entity?
      end
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

    def configure
      @description ||= ScenarioDescription.parse(self, &@scenario_block)
      self
    end
  end
end
