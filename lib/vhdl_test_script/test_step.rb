module VhdlTestScript
  class TestStep
    attr_reader :assign_mapping, :assert_mapping_before, :assert_mapping_after, :clock_mapping
    def self.divide_by_direction(mapping)
      ingroup, assert_mapping = mapping.
        partition{ |port, _| port.can_assign? }

      clock_mapping, assign_mapping = ingroup.partition{ |_, v| v == :rising_edge }
      [assign_mapping, Hash.new, assert_mapping, clock_mapping]
    end

    def initialize(assign_mapping, assert_mapping_before, assert_mapping_after, clock_mapping, origin_step = nil)
      @assign_mapping = assign_mapping
      @assert_mapping_before = assert_mapping_before
      @assert_mapping_after = assert_mapping_after
      @clock_mapping = clock_mapping
      @origin = origin_step
    end

    def to_vhdl
      stimuli.join("\n") + "\n" + down_clock.join("\n") + "\nwait for 1 ns;\n" +
        assertion(@assert_mapping_before) + up_clock.join("\n") +
        "\nwait for 1 ns;\n" + assertion(@assert_mapping_after)
    end

    def in(ports)
      mapping = [@assign_mapping, @assert_mapping_before, @assert_mapping_after, @clock_mapping].
        map { |m| m.select { |p,_| ports.member?(p) } }
      TestStep.new(*mapping, origin)
    end

    def origin
      @origin.nil? || @origin == self ? self : @origin.origin
    end

    private
    def stimuli
      @assign_mapping.map do |port, value|
        port.assignment(value)
      end
    end

    def down_clock
      @clock_mapping.map { |port, _| port.assignment_min }
    end

    def up_clock
      @clock_mapping.map { |port, _| port.assignment_max }
    end

    def assertion(mapping)
      inputs = @assign_mapping.map { |port, value| "#{port.name} = #{value}" }.join(", ").gsub(/\"/, "'")
      return '' if mapping.empty?
      cond = mapping.map { |port, value| port.equation(value) }.join(" and ")
      expected = mapping.map { |port, value| "#{port.name} = #{value}" }.join(", ").gsub(/\"/, "'")
      actual = mapping.map { |port, value| "#{port.name} = \" & to_string(#{port.name}) & \"" }.join(", ")
      %Q{assert #{ cond } report "FAILED: #{inputs} expected to #{expected}, but #{actual}" severity warning;\n}
    end
  end
end
