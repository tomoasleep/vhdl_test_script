module VhdlTestScript
  class Reporter
    def initialize(out = out)
      @out = out
    end

    def report_result(scenario, result)
      @out << result
      formatter = VhdlTestScript::ResultFormatter.new(result)
      @out << "\n\n\n"
      @out << formatter.format
      unless formatter.compile_error?
        @out << "\n#{scenario.steps.length} examples, #{formatter.count_failure} failures\n"
      end
      @out << "\nTest directory: #{scenario.tmpdir}\n"
    end
  end
end
