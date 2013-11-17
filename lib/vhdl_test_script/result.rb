module VhdlTestScript
  class TestFailure
    private
    def format_header
      "#@dutname #@context (Test Directory: #@tmpdir, Time: #@time)"
    end
  end

  class AssertFailure < TestFailure
    def initialize(dutname, tmpdir, context, time, cond, expected, actual)
      @dutname, @tmpdir, @context, @time, @cond, @expected, @actual =
        dutname, tmpdir, context, time, cond, expected, actual
    end

    def format
      "#{format_header}\n#{format_body}"
    end

    def compile_error?
      false
    end


    private
    def format_body
      body = []
      body << "FAILED: #@cond"
      body << "  expected: #@expected"
      body << "    actual: #@actual"
      body.join("\n")
    end
  end

  class CompileFailure < TestFailure
    def initialize(dutname, tmpdir, test_log = "")
      @dutname, @tmpdir, @test_log =
        dutname, tmpdir, test_log
    end

    def compile_error?
      true
    end

    def format
      "#{format_header}\n#{format_body}\n\n#@test_log"
    end

    def format_body
      "FAILED: Test did not run because of compilation error"
    end
  end

  class Result
    def self.parse(scenario, output)
      new(output, scenario.dut.name, scenario.tmpdir)
    end

    def initialize(output, dutname, tmpdir)
      @dutname, @tmpdir, @output = dutname, tmpdir, output 
    end

    def format
      failures.map(&:format).join("\n\n")
    end

    def failures
      return @failures ||= [CompileFailure.new(
        @dutname, @tmpdir, @output)] if compile_error?

      @failures ||= lines.reduce([]) do |failures, l|
          if l.match(/FAILED: (.*) expected to (.*), but (.*)/)
            cond, expected, actual = $1, $2, replace_binary($3)
            context = $1 if l.match(/In context (.*), FAILED:/)
            time = $1 if l.match(/:@(.*ps):\(assertion warning\)/)
            failures << AssertFailure.new(
              @dutname, @tmpdir, context, time, cond, expected, actual)
          end
          failures
      end
    end

    def compile_error?
      @output.include?("ghdl: compilation error") || @output.include?("ghdl: Please elaborate your design")
    end

    def succeeded?
      ! compile_error? && ! failed?
    end

    def failed?
      @output.include?("FAILED")
    end

    # convert binary expression in a string to decimal
    def replace_binary(str)
      str.gsub(/[01]+/) { |bin| bin.to_i(2).to_s(10) }
    end

    private
    def lines
      @output.split("\n")
    end
  end
end
