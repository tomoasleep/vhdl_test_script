module VhdlDoctest::Types
  class StdLogic
    def to_vhdl
      'std_logic'
    end

    def max_value
      1
    end

    def min_value
      0
    end

    def format(v)
      if [0, 1].include? v.to_i
        %Q{'#{v.to_i}'}
      elsif v.class == String
        v
      else
        # TODO: define error class
        raise "unacceptable value error #{v}"
      end
    end

    def self.parse(str)
      new if str.strip.downcase == 'std_logic'
    end
  end
end
