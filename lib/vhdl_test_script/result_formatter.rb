module VhdlTestScript
  class ResultFormatter
    def initialize(output)
      @output = output
    end

    # pretty print error message
    def format
      if compile_error?
        "FAILED: Test did not run because of compilation error"
      else
        lines.reduce([]) do |formatted, l|
          context = $1 if l.match(/(In context .*), FAILED:/)
          if l.match(/(FAILED: .*) expected to (.*), but (.*)/)
            formatted << "#{context}:" if context
            formatted << $1
            formatted << "  expected: " + $2
            formatted << "    actual: " + replace_binary($3)
          end
          formatted
        end.join("\n")
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

    def count_failure
      lines.select{ |l| l.match(/FAILED/) }.count
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
