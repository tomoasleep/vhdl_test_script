module VhdlTestScript
  class Mock < Actor
    def initialize(original_entity, scenario)
      @entity = original_entity.mocknize
      @scenario = scenario
    end

    def test_file
      @test_file ||=
        TestFile.new(self, File.expand_path(
          "../../../templetes/mock.vhd.erb", __FILE__))
    end
  end
end
