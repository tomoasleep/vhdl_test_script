module VhdlTestScript
  class Wait
    CLOCK_LENGTH = 2

    def initialize(length)
      @length = length
    end

    def to_vhdl
      "wait for #{@length * CLOCK_LENGTH} ns;"
    end

    def in(ports)
      self
    end


    def origin
      self
    end
  end
end
