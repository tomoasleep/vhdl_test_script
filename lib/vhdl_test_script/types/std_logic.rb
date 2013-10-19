module VhdlTestScript::Types
  class StdLogic
    def self.parse(str)
      new if str.strip.downcase == 'std_logic'
    end

    def to_vhdl
      'std_logic'
    end

    def origin_type
      self
    end

    def max_value
      1
    end

    def min_value
      0
    end

    def format(v)
      case v
      when VhdlTestScript::Value
        v.format(self)
      when String
        v
      else
        if [0, 1].include? v.to_i
          %Q{'#{v.to_i}'}
        else
          # TODO: define error class
          raise "unacceptable value error #{v}"
        end
      end
    end

    def primitive_type?
      true
    end
  end
end
