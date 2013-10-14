module VhdlDoctest
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

    def testcases_to_vhdl(cases)
      cases.map(&:to_vhdl).join("\n\n")
    end

    def with_test_prefix(name)
      "testbench_#{name}"
    end

    def utils
      @utils ||= File.read(
        File.expand_path("../../../templetes/util.vhd", __FILE__))
    end

    def define_library_use(package_names)
      libgroup = package_names.group_by {|n| n.split(".").first}
      libgroup.map { |k, a| 
        "library #{k};\n" + a.map {|l| "use #{l}.all;"}.join("\n")}.join("\n\n")
    end
  end
end
