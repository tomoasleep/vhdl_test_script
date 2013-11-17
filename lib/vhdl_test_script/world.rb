module VhdlTestScript
  class ScenarioGroup
    include Enumerable
    attr_reader :members
    def initialize(members = [])
      @members = members
    end

    def each(&block)
      @members.each &block
    end

    def with_tags(*tags)
      ScenarioGroup.new select {|s| tags.all? {|t| s.tags.include? t}}
    end

    def without_tags(*tags)
      ScenarioGroup.new select {|s| tags.none? {|t| s.tags.include? t}}
    end

    def <<(scenario)
      @members << scenario
    end

    def run
      each{|s| s.run(VhdlTestScript.configuration.scenario_options) }
      self
    end

    def report
      failures = map {|s| s.result.failures }.flatten
      step_length = map {|s| s.steps.length }.inject(:+) || 0
      VhdlTestScript.world.reporter.report_results failures, step_length
    end
  end

  class World
    attr_accessor :current_test_path
    attr_reader :vhdl_list, :dut, :scenario_group, :reporter
    def initialize
      @vhdl_list = []
      @scenario_group = ScenarioGroup.new
      @constants = {}
      @subtypes = {}
    end

    def register_scenario(scenario)
      @scenario_group << scenario
    end

    def register_vhdl(path)
      vhdl_list << path
    end

    def find_origin_type(subtype_name)
      @subtypes[subtype_name.strip.downcase]
    end

    def register_subtype(subtype_name, origin_type)
      @subtypes[subtype_name.strip.downcase] = origin_type
    end

    def find_const_type(const_name)
      @constants[const_name.strip.downcase]
    end

    def register_const_type(const_name, type)
      @constants[const_name.strip.downcase] = type
    end

    def register_out(out = STDOUT)
      @reporter = Reporter.new(out)
    end
  end
end
