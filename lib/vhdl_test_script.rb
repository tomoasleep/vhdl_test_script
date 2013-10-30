require "vhdl_test_script/vhdl_parser"
require "vhdl_test_script/actor"
require "vhdl_test_script/entity"
require "vhdl_test_script/port"
require "vhdl_test_script/generic"
require "vhdl_test_script/types"
require "vhdl_test_script/subtype"
require "vhdl_test_script/value"
require "vhdl_test_script/package"
require "vhdl_test_script/dsl"
require "vhdl_test_script/scenario"
require "vhdl_test_script/scenario_description"
require "vhdl_test_script/world"
require "vhdl_test_script/configuration"
require "vhdl_test_script/runner"
require "vhdl_test_script/runner_script"
require "vhdl_test_script/reporter"
require "vhdl_test_script/mock"
require "vhdl_test_script/test_step"
require "vhdl_test_script/test_bench"
require "vhdl_test_script/test_file_helper"
require "vhdl_test_script/test_file"
require "vhdl_test_script/result_formatter"
require "vhdl_test_script/wait"

module VhdlTestScript
  class << self
    def world
      @world ||= World.new
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def scenario(*args, &scenario_proc)
      world.register_scenario(Scenario.describe(*args, &scenario_proc))
    end
  end
end
