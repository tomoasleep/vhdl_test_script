module VhdlTestScript
  class Configuration
    attr_reader :out
    def initialize
      @loaded_pathes = []
    end

    def load_tests(test_pathes)
      test_pathes.each { |f|
        VhdlTestScript.world.current_test_path = f
        load File.expand_path(f)
      }
      VhdlTestScript.world.current_test_path = nil
      @loaded_pathes += test_pathes
    end

    def parse_options(options = {})
      if options[:out]
        VhdlTestScript.world.reporter = Reporter.new(options[:out])
      end
    end
  end
end
