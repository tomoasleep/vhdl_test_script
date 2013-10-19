module VhdlTestScript
  class TestFile
    attr_reader :scenario, :actor, :entity, :path, :file
    include VhdlTestScript::TestFileHelper

    def initialize(actor, templete_path)
      @scenario = actor.scenario
      @actor = actor
      @entity = actor.entity
      @templete_path = templete_path
    end

    def path
      if @path
        @path
      else
        raise "This test file is not yet instantiated"
      end
    end

    def name
      "test_" + actor.entity.name
    end

    def unitname
      with_test_prefix(actor.entity.name)
    end

    def create(dir)
      require 'erb'
      erb = ERB.new(File.read(@templete_path))
      obj_context = binding
      @path = File.join(dir, name + ".vhd")
      @file = File.open(@path, 'w') do |f|
        f << erb.result(obj_context)
      end
      self
    end
  end
end
