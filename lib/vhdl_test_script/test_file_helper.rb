module VhdlTestScript
  module TestFileHelper
    def ports_definitions(ports)
      ports.map(&:port_definition).join(";\n")
    end

    def signal_definitions(ports)
      ports.map(&:signal_definition).join("\n")
    end

    def dut_mappings(ports)
      ports.map(&:mapping).join(", ")
    end

    def generic_definition_mappings(generics)
      generics.map { |g| g.generic_definition }.join(";")
    end

    def generic_assign_mappings(generic_assigns)
      generic_assigns.map { |g, v| g.mapping(v) }.join(",")
    end

    def testcases_to_vhdl(steps)
      steps.map(&:to_vhdl).join("\n\n")
    end

    def with_test_prefix(name)
      "testbench_#{name}"
    end

    def define_library_use(package_names)
      package_names.map { |package_name| "use work.#{package_name}.all;"}.
        join("\n")
    end
  end
end
