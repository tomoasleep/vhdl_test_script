module VhdlTestScript
  class VhdlParser
    PORT_REGEXP = /port\s*\((?<ports>.*?)\);/im
    GENERIC_REGEXP = /generic\s*\((?<generics>.*?)\);/im
    PACKAGE_REGEXP = /package\s*(?<package_name>[a-zA-Z_0-9]*)\s*is\s+(?<package_decs>.*?)end\s*\k<package_name>\s*;/im

    ENTITY_REGEXP =
      /entity\s*(?<entity_name>[a-zA-Z_0-9]*)\s*is\s+(?:#{GENERIC_REGEXP})?\s*#{PORT_REGEXP}\s*end\s+\k<entity_name>\s*;/im
    COMPONENT_REGEXP =
      /component\s*(?<component_name>[a-zA-Z_0-9]*)\s*(?:#{GENERIC_REGEXP})?\s*#{PORT_REGEXP}\s*end\s+component\s*;/im
    CONSTANT_REGEXP =
      /constant\s*(?<constant_decs>.*?)$/im
    SUBTYPE_REGEXP =
      /subtype\s*(?<subtype_name>[a-zA-Z_0-9]*)\s*is\s+(?<subtype_decs>.*?)$/im
    class << self
      def read(path)
        new(File.read(path))
      end

      def parse_port_block(block)
        remove_comments(block).split(";").
          # "enable, push : in std_logic"
          map { |line| line.strip.split(':') }.
          # ["enable, push", "in std_logic"]
          select { |names, attrs| ! attrs.nil? }.
          map { |names, attrs| [names.split(','), *attrs.strip.split(' ', 2)]  }.
          # [["enable", " push"], in, std_logic]"
          map { |names, destination, type|
            names.map { |name|
              VhdlTestScript::Port.
                new(name.strip, destination.strip.to_sym,
                    VhdlTestScript::Types.parse(type)) }
          }.flatten
      end

      def parse_generic_block(block)
        remove_comments(block).split(";").
          # "enable, push : std_logic := '1'"
          map { |line| line.strip.split(":=") }.
          # ["enable, push : std_logic ", " '1'"]
          map { |line, default| [*line.strip.split(":"), default] }.
          # ["enable, push", "std_logic", " '1'"]
          select { |names, type, default| ! type.nil? }.
          map { |names, type, default| [names.split(','), type.strip,
                                        (default ? default.strip : nil)]  }.
          # [["enable", " push"], in, std_logic]"
          map { |names, type, default|
            names.map { |name|
              VhdlTestScript::Generic.
                new(name.strip, ty = VhdlTestScript::Types.parse(type),
                    (VhdlTestScript::Value.new(default, ty) if default)) }
          }.flatten
      end

      def parse_package_blocks(blocks)
        blocks.map do |b|
          constants = {}; subtypes = {}
          remove_comments(b.last).split(";").each do |line|
            if (c = line.match(CONSTANT_REGEXP))
              const_name, const_type = c[:constant_decs].split(":=").first.split(":")
              constants[const_name.strip.downcase] =
                VhdlTestScript::Types.parse(const_type.strip.downcase)
            elsif (s = line.match(SUBTYPE_REGEXP))
              subtype_type = s[:subtype_decs].split(":=").first.downcase
              subtypes[s[:subtype_name].downcase] =
                VhdlTestScript::Types.parse(subtype_type)
            end
          end
          VhdlTestScript::Package.new(b.first, constants, subtypes)
        end
      end


      def remove_comments(vhdl)
        (vhdl ? vhdl : "").gsub(/--.*$/, '')
      end
    end

    attr_accessor :dut, :ports, :cases
    def initialize(vhdl)
      @vhdl = vhdl
    end

    def test_file
      TestFile.new(entity_name, ports, generics, cases)
    end

    def ports
      @ports ||= VhdlParser.parse_port_block(port_block)
    end

    def generics
      @generics ||= VhdlParser.parse_generic_block(generics_block)
    end

    def packages
      @packages ||= VhdlParser.parse_package_blocks(package_blocks)
    end

    def entity
      @entity ||= Entity.new(entity_name, ports, generics, components) if have_entity?
    end

    def components
      @components ||= component_blocks.map { |item|
        name, generics, ports = item
        Entity.new(name, VhdlParser.parse_port_block(ports),
                   VhdlParser.parse_generic_block(generics))
      }
    end

    def port_block
      (e = @vhdl.match(ENTITY_REGEXP)) ? e[:ports] : nil
    end

    def generics_block
      (e = @vhdl.match(ENTITY_REGEXP)) ? e[:generics] : nil
    end

    def package_blocks
      @vhdl.scan(PACKAGE_REGEXP)
    end

    def component_blocks
      @vhdl.scan(COMPONENT_REGEXP)
    end

    def have_entity?
      @entity || !@vhdl.match(ENTITY_REGEXP).nil?
    end

    def entity_name
      @vhdl.match(/entity\s+([a-zA-Z_0-9]*)\s+is/)[1] if have_entity?
    end

    def dependencies
      @vhdl.split("\n").
        select { |line| line.include?('DOCTEST DEPENDENCIES') }.
        map { |line| line.split(":")[1].split(",") }.
        flatten.
        map { |file| file.strip }
    end
  end
end
