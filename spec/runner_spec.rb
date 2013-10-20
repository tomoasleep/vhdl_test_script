require 'spec_helper'

module VhdlTestScript
  describe Runner do
    describe "#run" do
      let(:out) { StringIO.new }
      subject { out.rewind; out.read }
      before { described_class.new([testfile], out: out).run }

      context "4 successful examples" do
        let(:testfile) { "examples/latch_test.rb" }

        it { should match "4 examples, 0 failures" }
      end

      context "10 successful examples" do
        let(:testfile) { "examples/state_machine_test.rb" }

        it { should match "10 examples, 0 failures" }
      end

      context "DSL.step can read hash arguments" do
        context "1 successful examples" do
          let(:testfile) { "examples/latch_test_hash.rb" }

          it { should match "1 examples, 0 failures" }
        end
      end

      context "use mock" do
        context "4 successful examples" do
          let(:testfile) { "examples/datapath_test.rb" }

          it { should match "4 examples, 0 failures" }
        end
      end

      context "use subtype" do
        context "10 successful examples" do
          let(:testfile) { "examples/state_machine_subtype_test.rb" }

          it { should match "10 examples, 0 failures" }
        end
      end
    end
  end
end
