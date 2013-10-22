module VhdlTestScript
  class World
    attr_accessor :current_test_path
    attr_reader :vhdl_list, :dut, :scenario_list, :reporter
    def initialize
      @vhdl_list = []
      @scenario_list = []
      @constants = {}
      @subtypes = {}
    end

    def register_scenario(scenario)
      @scenario_list << scenario
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
