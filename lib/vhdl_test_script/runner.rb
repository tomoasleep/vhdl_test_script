module VhdlTestScript
  class Runner
    def initialize(test_pathes, options = {})
      @test_pathes = test_pathes
      @options = options
    end

    def run
      config = VhdlTestScript.configuration
      world = VhdlTestScript.world

      config.parse_options(@options)
      config.load_tests(@test_pathes)

      include_tags = config.include_tags
      exclude_tags = config.exclude_tags

      world.reporter.report_run_option

      world.scenario_group.
        with_tags(*include_tags).without_tags(*exclude_tags).run.report
    end
  end
end
