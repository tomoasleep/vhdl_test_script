module VhdlTestScript
  UTIL_PATH = File.expand_path("../../../templetes/util.vhd", __FILE__)

  class RunnerScript
    def initialize(dir, dependency_pathes, dut_path, testbench_path, unitname)
      @testbench_path = testbench_path
      @dut_path = dut_path
      #@mock_pathes = mock_pathes
      @dependency_pathes = [UTIL_PATH] + dependency_pathes
      @dir = dir
      @unitname = unitname
      create_runner_script
    end

    def create_runner_script
      require 'erb'
      @sh = File.join(@dir, "run.sh")
      erb = ERB.new(File.read(
        File.expand_path("../../../templetes/runner_script.sh.erb", __FILE__)))
      erb = erb.result(binding)

      File.open(@sh, 'w') do |f|
        f << erb
      end
    end

    def run
      result = ""

      IO.popen("sh #{@sh} 2>&1") do |f|
        output = f.read
        result << output
      end
      result
    end
  end
end
