module VhdlTestScript
  class TestStep
    attr_reader :in_mapping, :out_mapping, :colck_mapping
    def self.divide_by_direction(mapping)
      ingroup, out_mapping = mapping.
        partition{ |port, _| port.in? }

      clock_mapping, in_mapping = ingroup.partition{ |_, v| v == :rising_edge }
      [in_mapping, out_mapping, clock_mapping]
    end

    def initialize(in_mapping, out_mapping, clock_mapping)
      @in_mapping = in_mapping
      @out_mapping = out_mapping
      @clock_mapping = clock_mapping
    end

    def to_vhdl
      stimuli.join("\n") + down_clock.join("\n") + "\nwait for 1 ns;\n" + up_clock.join("\n") +
        "\nwait for 1 ns;\n" + assertion
    end

    def reverse
      TestStep.new(@out_mapping, @in_mapping, @clock_mapping)
    end

    def in(ports)
      mapping = [@in_mapping, @out_mapping, @clock_mapping].
        map { |m| m.select { |p,_| ports.member?(p) } }
      TestStep.new(*mapping)
    end

    private
    def stimuli
      @in_mapping.map do |port, value|
        port.assignment(value)
      end
    end

    def down_clock
      @clock_mapping.map { |port, _| port.assignment_min }
    end

    def up_clock
      @clock_mapping.map { |port, _| port.assignment_max }
    end

    def assertion
      inputs = @in_mapping.map { |port, value| "#{port.name} = #{value}" }.join(", ")
      return '' if @out_mapping.empty?
      cond = @out_mapping.map { |port, value| port.equation(value) }.join(" and ")
      expected = @out_mapping.map { |port, value| "#{port.name} = #{value}" }.join(", ")
      actual = @out_mapping.map { |port, value| "#{port.name} = \" & to_string(#{port.name}) & \"" }.join(", ")
      %Q{assert #{ cond } report "FAILED: #{inputs} expected to #{expected}, but #{actual}" severity warning;}
    end
  end
end
