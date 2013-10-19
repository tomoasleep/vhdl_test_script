require 'spec_helper'

module VhdlTestScript
  describe VhdlParser do
    let(:sample_vhdl) { 'examples/alu.vhd' }
    describe 'dut' do
      subject(:dut) { VhdlParser.read(sample_vhdl) }

      its(:entity_name) { should == "alu" }
      it { should have(5).dut.ports }
      it { should have(0).dut.components }
    end

    describe 'components' do
      let(:vhdl_path) { 'examples/datapath.vhd' }
      subject(:components) { VhdlParser.read(vhdl_path).entity.components }

      it { should have(1).items }
      its('first.name') { should == "state_machine" }
      its('first') { should have(4).ports }
    end

    describe 'ports' do
      subject(:ports) { VhdlParser.read(sample_vhdl).entity.ports }

      it { should have(5).items }
      its('first.port_definition') { should == "a : in std_logic_vector(31 downto 0)" }
      its('last.port_definition') { should == "zero : out std_logic" }
    end

    describe 'generics' do
      let(:vhdl_path) { 'examples/alu_generic.vhd' }
      subject(:generics) { VhdlParser.read(vhdl_path).entity.generics }

      it { should have(1).items }
      its('first.generic_definition') { should == "hoge : std_logic := '1'" }
    end

    describe 'packages' do
      let (:vhdl_path) { 'examples/state_machine_lib.vhd' }
      subject(:packages) { VhdlParser.read(vhdl_path).packages }

      it { should have(2).items }
      its('first.name') { should == "const_state" }
    end
  end
end
