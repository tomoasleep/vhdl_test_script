module VhdlTestScript
  class Package
    attr_reader :name, :constants, :subtypes
    def initialize(name, constants = {}, subtypes = {})
      @name = name
      @constants = constants
      @subtypes = subtypes
    end
  end
end
