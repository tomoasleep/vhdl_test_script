module VhdlTestScript
  class Subtype
    def initialize(typename)
      @typename = typename.strip.downcase
    end

    def origin_type
      VhdlTestScript.world.find_origin_type(@typename)
    end

    def to_vhdl
      @typename
    end

    def format(v)
      raise "#{@typename} has no primitive origin type" if !origin_type || !origin_type.primitive_type?
      origin_type.format(v)
    end

    def primitive_type?
      false
    end
  end
end
