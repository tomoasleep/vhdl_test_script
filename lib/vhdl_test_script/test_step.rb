module VhdlTestScript
  class TestStep
    attr_reader :assign_mapping, :assert_mapping_before, :assert_mapping_after
    # TODO this name should be renamed to such as 'divide_by_assert_type'.
    def self.divide_by_direction(mapping)
      assign_mapping, assert_mapping = mapping.
        partition{ |port, _| port.can_assign? }

      # TODO: Use hash {assert: portmaps, assign_before: portmaps, assign: portmaps}
      [assign_mapping, Hash.new, assert_mapping]
    end

    def initialize(assign_mapping, assert_mapping_before, assert_mapping_after, origin_step = nil, name = nil)
      @assign_mapping = assign_mapping
      @assert_mapping_before = assert_mapping_before
      @assert_mapping_after = assert_mapping_after
      @origin = origin_step
      @name = name
    end

    def to_vhdl
      stimuli.join("\n") + "\n" + "\nwait for 0.5 ns;\n" +
        assertion(@assert_mapping_before) + "\nwait for 1 ns;\n" +
        assertion(@assert_mapping_after) + "\nwait for 0.5 ns;\n"
    end

    def in(ports)
      mapping = [@assign_mapping, @assert_mapping_before, @assert_mapping_after].
        map { |m| m.select { |p,_| ports.member?(p) } }
      TestStep.new(*mapping, origin, @name)
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

    def assertion(mapping)
      inputs = @assign_mapping.map { |port, value| "#{port.name} = #{value}" }.join(", ").gsub(/\"/, "'")
      return '' if mapping.empty?
      cond = mapping.map { |port, value| port.equation(value) }.join(" and ")
      expected = mapping.map { |port, value| "#{port.name} = #{value_parse(value)}" }.join(", ").gsub(/\"/, "'")
      actual = mapping.map { |port, value| "#{port.name} = 0x\" & to_hstring(#{port.name}) & \" (\" & to_string(#{port.name}) & \")" }.join(", ")
      %Q{assert #{ cond } report "#{ "In context #@name, " if @name }FAILED: #{inputs} expected to #{expected}, but #{actual}" severity warning;\n}
    end

    def value_parse(value)
      case value
      when Integer
        "0x#{value.to_s(16).rjust(8, '0')} (#{value})"
      when Float
        value_parse([value].pack("f").unpack("I").first)
      else
        value
      end
    end
  end
end
