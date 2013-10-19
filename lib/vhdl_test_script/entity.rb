module VhdlTestScript
  class Entity
    attr_reader :name, :components, :ports, :generics
    def initialize(name, ports, generics, components = [])
      @name = name
      @ports = ports
      @generics = generics
      @components = components
    end

    def testbench(scenario)
      @testbench ||= TestFile.new(entity, scenario)
    end
  end
end
