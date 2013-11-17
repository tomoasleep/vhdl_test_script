module VhdlTestScript
  class Reporter
    def config
      VhdlTestScript.configuration
    end

   def initialize(out = out)
      @out = out
    end

    def report_test_header(dutname, tmpdir)
      @out << "#{dutname} (Test directory: #{tmpdir})"
      @out << "\n"
    end

    def print(output)
      @out << output
    end

    def report_output(output)
      @out << output
      @out << "\n\n"
    end

    def report_run_option
      return if config.include_tags.empty? && config.exclude_tags.empty?
      @out << "Run options:"
      @out << " include {#{config.include_tags.map(&:inspect).join(", ")}}" unless config.include_tags.empty?
      @out << " exclude {#{config.exclude_tags.map(&:inspect).join(", ")}}" unless config.exclude_tags.empty?
      @out << "\n\n"
    end

    def report_results(failures, step_length)
      @out << "\nFailures: \n\n" unless failures.empty?
      @out << failures.map.with_index(1) {|f, i| "#{i}) " + f.format }.join("\n\n")
      @out << "\n\n#{step_length} steps, #{failures.length} failures\n\n"
    end
  end
end
