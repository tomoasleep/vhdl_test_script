module VhdlTestScript
  class Mock < Actor
    def steps
      @steps ||= @scenario.steps.map do |step|
        step.in(@entity.ports).reverse
      end
    end

    def test_file
      @test_file ||=
        TestFile.new(self, File.expand_path(
          "../../../templetes/mock.vhd.erb", __FILE__))
    end
  end
end
