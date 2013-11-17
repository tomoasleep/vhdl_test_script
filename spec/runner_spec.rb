require 'spec_helper'

module VhdlTestScript
  describe Runner do
    describe "#run" do
      let(:out) { StringIO.new }
      subject { out.rewind; out.read }
      before { VhdlTestScript.reset; described_class.new([testfile], out: out).run }

      context "4 successful steps" do
        let(:testfile) { "examples/latch_test.rb" }

        it { should match "4 steps, 0 failures" }
      end

      context "10 successful steps" do
        let(:testfile) { "examples/state_machine_test.rb" }

        it { should match "10 steps, 0 failures" }
      end

      context "DSL.step can read hash arguments" do
        context "1 successful steps" do
          let(:testfile) { "examples/latch_test_hash.rb" }

          it { should match "1 steps, 0 failures" }
        end
      end

      context "use mock" do
        context "4 successful steps" do
          let(:testfile) { "examples/datapath_test.rb" }

          it { should match "4 steps, 0 failures" }
        end
      end

      context "use subtype" do
        context "10 successful steps" do
          let(:testfile) { "examples/state_machine_subtype_test.rb" }

          it { should match "10 steps, 0 failures" }
        end
      end

      context "tag" do
        before { VhdlTestScript.reset; described_class.new(
          [testfile], out: out, include_tags: include_tags, exclude_tags: exclude_tags).run }

        context "include_tags :y" do
          context "3 steps, 2 failures" do
            let(:testfile) { "examples/latch_test_tag.rb" }
            let(:include_tags) {[:y]}
            let(:exclude_tags) {[]}

            it { expect(subject).to match "3 steps, 2 failures" }
          end
        end

        context "exclude_tags :x" do
          context "2 steps, 1 failure" do
            let(:testfile) { "examples/latch_test_tag.rb" }
            let(:include_tags) {[]}
            let(:exclude_tags) {[:x]}


            it { expect(subject).to match "2 steps, 1 failure" }
          end
        end
      end
    end
  end
end
