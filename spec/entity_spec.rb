require 'spec_helper'

module VhdlTestScript
  describe Entity do
    describe "#mocknize" do
      subject { entity }
      let(:entity) {
        Entity.new("test", 
                   [Port.new("input", :in, Types::StdLogic),
                    Port.new("output", :out, Types::StdLogic)],
                   [])}
      it { 
        expect(subject.ports.length).to  eq(2)
        expect(subject.mocknize.ports.length).to  eq(2)
      }
      it {
        expect(subject.ports.find {|po| po.name == "input"}.can_assign?).to  be_true
        expect(subject.ports.find {|po| po.name == "output"}.can_assign?).to  be_false
      }
      it {
        expect(subject.mocknize.ports.find {|po| po.name == "input"}.can_assign?).to  be_false
        expect(subject.mocknize.ports.find {|po| po.name == "output"}.can_assign?).to  be_true
      }
    end

  end
end
