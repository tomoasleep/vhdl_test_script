module VhdlTestScript
  class Actor
    attr_reader :entity, :scenario, :example
    attr_accessor :clock
    def self.world
      VhdlTestScript.world
    end

    def initialize(entity, scenario)
      @entity = entity
      @scenario = scenario
    end

    def steps
      @steps ||= @scenario.steps.map do |step|
        step.in(@entity.ports)
      end
    end

    def generic_assigns
      @generic_assigns ||= @scenario.generic_assigns.select do |generic, _|
        entity.generics.any? { |g| generic == g }
      end
    end

    def test_file
      @test_file ||=
        TestFile.new(self, File.expand_path(
          "../../../templetes/test_bench.vhd.erb", __FILE__))
    end
  end
end
