require "vhdl_doctest/DSL/base.rb"

module VhdlDoctest::DSL
  def self.load_dsl(dut, path)
    dsl_klass = path.split("/").last.split(".").first.split("_").map(&:capitalize).join
    Object.const_set(dsl_klass, Class.new(VhdlDoctest::DSL::Base))

    load(path)
    dsl_class = Object.const_get(dsl_klass).new(dut.ports)

    VhdlDoctest::TestFile.new(dut.entity, dut.ports, dsl_class.cases)
  end
end
