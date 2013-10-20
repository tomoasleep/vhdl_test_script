require 'vhdl_test_script/types/std_logic'
require 'vhdl_test_script/types/std_logic_vector'

module VhdlTestScript
  module Types
    def self.parse(str)
      Types.constants.each do |c|
        klass = const_get("#{c}")
        next unless klass.respond_to?(:parse)
        if result = klass.parse(str)
          return result
        end
      end
      VhdlTestScript::Subtype.new(str)
      # raise "Type for #{str} is not found."
    end
  end
end
