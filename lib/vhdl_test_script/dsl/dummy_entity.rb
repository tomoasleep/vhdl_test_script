module VhdlTestScript::DSL
  class DummyEntity
    class UndefinedPortError < NoMethodError; end
    def initialize(entity)
      @entity = entity
    end

    def method_missing(action, *args)
      action_name = action.to_s
      port_by_name = @entity.ports.find {|p| p.name == action_name }
      if port_by_name
        port_by_name
      else
        raise UndefinedPortError, "undefined port '#{action_name}'"
      end
    end
  end
end
