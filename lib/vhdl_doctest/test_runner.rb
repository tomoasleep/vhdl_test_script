module VhdlDoctest
  class TestRunner
    def initialize(out, dut_path, test_file, dependencies = [])
      @out = out
      @dut_path = File.expand_path(dut_path)
      @test_file = test_file
      @dependencies = dependencies

      require 'tmpdir'
      @dir = Dir.mktmpdir
    end

    def run
      create_files
      run_test
      report_result
    end

    def create_files
      @test_file.create(@dir)
      create_runner_script
    end

    def dependencies
      dut_dir = File.dirname(@dut_path)
      @dependencies.map { |path| File.expand_path(path, dut_dir) }
    end

    def create_runner_script
      require 'erb'
      @sh = File.join(@dir, "run.sh")
      erb = ERB.new(File.read(
        File.expand_path("../../../templetes/test_runner.sh.erb", __FILE__)))
      erb = erb.result(binding)

      File.open(@sh, 'w') do |f|
        f << erb
      end
    end

    private
    def run_test
      @result = ""

      IO.popen("sh #{@sh} 2>&1") do |f|
        output = f.read
        @result << output
        @out << output
      end
    end

    def report_result
      formatter = ResultFormatter.new(@result)
      @out << "\n\n\n"
      @out << formatter.format
      unless formatter.compile_error?
        @out << "\n#{@test_file.cases.size} examples, #{formatter.count_failure} failures\n"
      end
      @out << "\nTest directory: #{@dir}\n"
    end
  end
end
