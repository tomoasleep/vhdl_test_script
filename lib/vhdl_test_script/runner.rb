module VhdlTestScript
  class Runner
    def initialize(test_pathes, options = {})
      @test_pathes = test_pathes
      @options = options
    end

    def run(config = VhdlTestScript.configuration, world = VhdlTestScript.world)
      config.parse_options(@options)
      config.load_tests(@test_pathes)

      world.scenario_list.each { |scenario| scenario.run }
    end
  end
end
