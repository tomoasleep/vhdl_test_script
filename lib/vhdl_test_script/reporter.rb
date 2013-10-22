module VhdlTestScript
  class Reporter
    def initialize(out = out)
      @out = out
    end

    def report_result(scenario, result_formatter)
      @out << "\n\n\n"
      @out << result_formatter.format
      unless result_formatter.compile_error?
        @out << "\n#{scenario.steps.length} examples, #{result_formatter.count_failure} failures\n"
      end
      @out << "\nTest directory: #{scenario.tmpdir}\n"
    end

    def output(output)
      @out << output
    end
  end
end
