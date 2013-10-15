module VhdlDoctest::DSL
  class Base
    attr_reader :package_names

    def self.dsl(&prc)
      @@proc = prc
    end

    def initialize(ports)
      @dup_ports = ports
      @package_names = []
    end 

    def assign(*ports)
      assign_test_ports(*ports)
    end

    def clock(name)
      @clock = dupport_by_name(name)
    end

    def step(*ups)
      @cases << gen_step(ups)
    end

    def require_package(*names)
      @package_names += names
    end

    def to_vhdl
      cases.map(&:to_vhdl).join("\n")
    end

    def _
      :dont_care
    end

    def cases
      invoke unless @cases
      @cases
    end

    private
    def assign_test_ports(*names)
      @test_ports = names.map{|i| dupport_by_name i}
    end

    def gen_step(ups) 
      case ups.first
      when Hash
        VhdlDoctest::TestCase.new(
          add_clockupdate(Hash[ups.first.map { |k, v| [dupport_by_name(k), v]}])
        )
      else
        VhdlDoctest::TestCase.new(
          add_clockupdate(Hash[@test_ports.zip(ups)])
        )
      end
    end

    def testport_by_name(name)
      port_by_name(@test_ports, name)
    end

    def dupport_by_name(name)
      port_by_name(@dup_ports, name)
    end

    def port_by_name(ports, name)
      ports.find {|p| p.name.to_sym == name.to_sym}
    end

    def add_clockupdate(hash)
      hash[@clock] = :rising_edge if @clock
      hash
    end

    def invoke
      @cases = Array.new
      instance_eval &@@proc
    end

  end
end

