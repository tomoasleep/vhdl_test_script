module VhdlDoctest::DSL
  class TestBench
    def initialize(dut, path)
      @dut = dut
      dsl_klass = path.split("/").last.split(".").first.split("_").map(&:capitalize).join
      Object.const_set(dsl_klass, Class.new(VhdlDoctest::DSL::Base))

      load(path)
      @dsl_class = Object.const_get(dsl_klass).new(dut.ports)
    end

    def to_test_file
      VhdlDoctest::TestFile.new(@dut.entity, @dut.ports, @dsl_class.cases)
    end

    def to_vhdl
      @dsl_class.to_vhdl
    end
  end
end
