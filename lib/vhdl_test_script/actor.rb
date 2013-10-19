module VhdlTestScript
  class Actor
    attr_reader :entity, :scenario, :example
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

    def test_file
      @test_file ||=
        TestFile.new(self, File.expand_path(
          "../../../templetes/test_bench.vhd.erb", __FILE__))
    end
  end
end
