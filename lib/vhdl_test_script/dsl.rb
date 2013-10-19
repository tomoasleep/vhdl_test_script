module VhdlTestScript
  module DSL
    def self.port_by_name(ports, name)
      ports.find {|p| p.name.to_sym == name.to_sym}
    end

    def ports(*ports)
      assign_test_ports(*ports)
    end

    def clock(name)
      @clock = @scenario.port_by_name(name)
    end

    def step(*ups)
      @scenario.steps << gen_step(ups)
    end

    def dependencies(*pathes)
      @scenario.load_dependencies(pathes)
    end

    def require_package(*names)
      @package_names += names
    end

    def use_mock(*names)
      names.each do |name|
        @scenario.use_mock(name)
      end
    end

    def _
      :dont_assign
    end

    private
    def assign_test_ports(*names)
      @testports = names.map{|i| @scenario.port_by_name i}
    end

    def gen_step(ups)
      case ups.first
      when Hash
        assignments = remove_not_assign(
          add_clockupdate(Hash[ups.first.map { |k, v| [scenario.port_by_name(k), v]}]))
        TestStep.new(
          *TestStep.divide_by_direction(assignments)
        )
      else
        assignments = remove_not_assign(add_clockupdate(Hash[@testports.zip(ups)]))
        TestStep.new(
          *TestStep.divide_by_direction(assignments)
        )
      end
    end

    def add_clockupdate(hash)
      hash[@clock] = :rising_edge if @clock
      hash
    end

    def remove_not_assign(hash)
      Hash[hash.select{|_,v| v != :dont_assign}]
    end
  end
end
