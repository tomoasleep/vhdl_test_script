module VhdlTestScript::Types
  class StdLogicVector
    def self.parse(str)
      str = str.strip
      if str.match(/\Astd_logic_vector/i)
        if str.strip.match(/\((\d+)\s+downto\s+0\)\Z/i)
          new($1.to_i + 1)
        else
          raise "#{ str } is std_logic_vector, but not 'x downto 0'"
        end
      end
    end

    def initialize(length)
      @length = length
    end

    def origin_type
      self
    end

    def max_value
      2**@length - 1
    end

    def min_value
      0
    end

    def to_vhdl
      "std_logic_vector(#{@length-1} downto 0)"
    end

    def all_assign(v)
      "\"#{v * @length}\""
    end

    def format(v)
      case v
      when VhdlTestScript::Value
        v.format(self)
      when String
        v
      when Float
        v_to_int =  [v].pack("f").unpack("I").first
        format(v_to_int)
      else
        '"' + (2**@length + v).to_s(2)[-@length.. -1]+ '"'
      end
    end

    def primitive_type?
      true
    end
  end
end
