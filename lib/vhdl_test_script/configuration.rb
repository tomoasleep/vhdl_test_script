module VhdlTestScript
  class Configuration
    attr_reader :out, :include_tags, :exclude_tags, :verbose
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
      out = options[:out] ? options[:out] : STDOUT
      @include_tags = options[:include_tags] ? options[:include_tags] : []
      @exclude_tags = options[:exclude_tags] ? options[:exclude_tags] : []
      @verbose = options[:verbose]
      VhdlTestScript.world.register_out(out)
    end

    def scenario_options
      options = {
        verbose: verbose
      }
    end
  end
end
