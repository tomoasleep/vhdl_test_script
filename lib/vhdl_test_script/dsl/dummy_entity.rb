module VhdlTestScript::DSL
  class DummyEntity
    def initialize(entity)
      @entity = entity
    end

    def method_missing(action, *args)
      action_name = action.to_s
      port_by_name = @entity.ports.find {|p| p.name == action_name }
      if port_by_name
        port_by_name
      else
        raise NoMethodError
      end
    end
  end
end
