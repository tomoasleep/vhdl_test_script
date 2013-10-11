module VhdlDoctest
  class TestFile
    attr_reader :cases
    include VhdlDoctest::TestFileHelper

    def initialize(dut_entity, ports, cases)
      @dut_entity = dut_entity
      @ports = ports
      @cases = cases
    end

    def path
      if @path
        @path
      else
        raise "This test file is not yet instantiated"
      end
    end

    def test_name
      with_test_prefix(@dut_entity)
    end

    def create(dir)
      require 'erb'
      erb = ERB.new(File.read(
        File.expand_path("../../../templetes/testcode.vhd.erb", __FILE__)))
      obj_context = binding 
      @path = File.join(dir, test_name + ".vhd")
      File.open(@path, 'w') do |f|
        f << erb.result(obj_context)
      end
    end
  end
end
