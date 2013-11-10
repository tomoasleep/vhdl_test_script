require 'spec_helper'
module VhdlTestScript
  describe Scenario do
    describe "scenario" do
      before { VhdlTestScript.world.register_out(StringIO.new) }
      subject(:scenario) { Scenario.new(dut_path, File.expand_path(__FILE__), &test_proc).parse_description }

      context "parse step block" do
        let(:dut_path) { "../examples/register_file.vhd" }
        let(:test_proc) { Proc.new { |dut|
          ports :input, :output, :update, :reg
          clock :clk

          step do
            assign input: 2, update: 1
            assert_before reg: 1
            assert_after reg: 2, output: 2
          end
        } }

        it {
          expect(subject.steps.first.assign_mapping.length).to eq(2)
          expect(subject.steps.first.assert_mapping_before.length).to eq(1)
          expect(subject.steps.first.assert_mapping_after.length).to eq(2)
        }
      end

      context "parse generic" do
        let(:dut_path) { "../examples/register_file.vhd" }
        let(:test_proc) { Proc.new { |dut|
          clock :clk
          generics value: 3

          step do
            assign input: 2, update: 1
            assert_before reg: 1, genericv: 3
            assert_after reg: 2, output: 2
          end
        } }

        it {
          expect(subject.generic_assigns.length).to eq(1)
        }
      end
    end

    describe ".run" do
      before { VhdlTestScript.world.register_out(StringIO.new) }
      subject(".run") { Scenario.new(dut_path, File.expand_path(__FILE__), &test_proc).run }

      context "assign clock" do
        let(:dut_path) { "../examples/latch.vhd" }
        context "1 successful step" do
          let(:test_proc) { Proc.new { |dut|
            ports :a, :output
            clock :clk
            step 1, 1
          } }

          it {
            expect(subject.result.succeeded?).to be_true
            expect(subject.steps.length).to eq(1)
          }
        end

        context "1 fail step" do
          let(:test_proc) { Proc.new { |dut|
            ports :a, :output
            clock :clk
            step 1, 0
          } }

          it {
            expect(subject.result.failed?).to be_true
            expect(subject.result.count_failure).to eq(1)
            expect(subject.steps.length).to eq(1)
          }
        end
      end

      context "dont assign clock" do
        let(:dut_path) { "../examples/latch.vhd" }
        context "2 fail steps" do
          let(:test_proc) { Proc.new { |dut|
            ports :a, :output
            step 1, 1
            step 0, 0
          } }

          it {
            expect(subject.result.failed?).to be_true
            expect(subject.result.count_failure).to eq(2)
            expect(subject.steps.length).to eq(2)
          }
        end
      end

      context "parse :dont_assign" do
        context "4 successful steps" do
          let(:dut_path) { "../examples/latch.vhd" }
          let(:test_proc) { Proc.new { |dut|
            ports :a, :output
            clock :clk
            step 1, 1
            step _, 1
            step 2, _
            step _, 2
          } }

          it {
            expect(subject.result.succeeded?).to be_true
            expect(subject.steps.length).to eq(4)
          }
        end
      end

      context "parse hash step" do
        context "1 successful step" do
          let(:dut_path) { "../examples/latch.vhd" }
          let(:test_proc) { Proc.new { |dut|
            ports :a, :output
            clock :clk
            step a: 1, output: 1
          } }

          it { expect(subject.result.succeeded?).to be_true }
          it { expect(subject.steps.length).to eq(1) }
        end
      end

      context "can create mock" do
        context "4 successful steps" do
          let(:dut_path) { "../examples/datapath.vhd" }
          let(:test_proc) { Proc.new { |dut|
            s = use_mock :state_machine
            ports dut.input, dut.output, s.input, s.reset, s.state
            clock dut.clk

            step 1, 2, 1, 0, 2
            step 2, 1, 0, 1, 1
            step _, 1, 0, 1, 1
            step 3, 1, 1, 1, 1
          } }

          it {
            expect(subject.result.succeeded?).to be_true
            expect(subject.steps.length).to eq(4)
          }
        end
      end

      context "with component" do
        context "3 successful steps" do
          let(:dut_path) { "../examples/datapath.vhd" }
          let(:test_proc) { Proc.new { |dut|
            dependencies "../examples/state_machine_lib.vhd",
              "../examples/state_machine.vhd"

            ports dut.input, dut.output
            clock dut.clk

            step 3, "STATE_A"
            step 1, "STATE_B"
            step 0, "STATE_C"
          } }

          it {
            expect(subject.result.succeeded?).to be_true
            expect(subject.steps.length).to eq(3) 
          }
        end
      end

      context "can use subtype" do
        context "10 successful steps" do
          let(:dut_path) { "../examples/state_machine_subtype.vhd" }
          let(:test_proc) { Proc.new { |dut|
            ports :input, :reset, :state
            clock :clk
            dependencies "../examples/state_machine_lib.vhd"

            testcases = [
              ["ORDER_B", "STATE_F"],
              ["ORDER_A", "STATE_G"],
              ["ORDER_A", "STATE_E"],
              ["ORDER_A", "STATE_F"],
              ["ORDER_B", "STATE_E"],
              ["ORDER_A", "STATE_F"],
              ["ORDER_A", "STATE_G"],
              ["ORDER_B", "STATE_H"],
              ["ORDER_A", "STATE_E"]
            ]

            step "ORDER_A", 1, "STATE_E"

            testcases.each do |i|
              step i.first, 0, i.last
            end

          } }

          it {
            expect(subject.result.succeeded?).to be_true
            expect(subject.steps.length).to eq(10)
          }
        end
      end

      context "can use unix regexp" do
        context "3 successful steps" do
          let(:dut_path) { "../examples/datapath.vhd" }
          let(:test_proc) { Proc.new { |dut|
            ports :input, :output
            clock :clk
            dependencies "../examples/components/*"


            step 1, 1
            step 2, 6
            step 3, 7
          } }

          it {
            expect(subject.result.succeeded?).to be_true
            expect(subject.steps.length).to eq(3)
          }
        end
      end

      context "can use group step" do
        context "3 successful steps" do
          let(:dut_path) { "../examples/register_file.vhd" }
          let(:test_proc) { Proc.new { |dut|
            ports :input, :output, :update, :reg
            clock :clk

            step 1, 1, 1, 1
            step do
              assign input: 2, update: 1
              assert_before reg: 1
              assert_after reg: 2, output: 2
            end
            step do
              assign input: 2, update: 1
              assert_after reg: 2, output: 2
            end
          } }

          it {
            expect(subject.result.succeeded?).to be_true
            expect(subject.steps.length).to eq(3)
          }
        end

        context "2 successful steps" do
          let(:dut_path) { "../examples/register_file.vhd" }
          let(:test_proc) { Proc.new { |dut|
            cl = use_mock :calculator
            clock dut.clk

            step do
              assign dut.input => 2, dut.update => 1, cl.output => 4
              assert_after dut.calc_result => 4, dut.output => 2
            end
            step do
              assign dut.input => 3, dut.update => 1, cl.output => 6
              assert_before dut.calc_result => 4
              assert_after dut.calc_result => 6, dut.output => 3
            end
          } }

          it {
            expect(subject.result.succeeded?).to be_true
            expect(subject.steps.length).to eq(2)
          }
        end
      end

      context "parse generic" do
        context "1 successful step" do
          let(:dut_path) { "../examples/register_file.vhd" }
          let(:test_proc) { Proc.new { |dut|
            clock :clk
            generics value: 3

            step do
              assign input: 2, update: 1
              assert_before genericv: 3
              assert_after reg: 2, output: 2
            end
          } }

          it {
            expect(subject.result.succeeded?).to be_true
            expect(subject.steps.length).to eq(1)
          }
        end
      end

      context "parse wait_step" do
        context "1 successful step" do
          let(:dut_path) { "../examples/state_machine.vhd" }
          let(:test_proc) { Proc.new { |dut|
            dependencies "../examples/state_machine_lib.vhd"
            clock :clk

            step reset: 1, state: "STATE_A"
            step reset: 0
            wait_step 2
            step input: "ORDER_A", state: "STATE_C"
          } }

          it {
            expect(subject.result.succeeded?).to be_true
            expect(subject.steps.length).to eq(4)
          }
        end
      end

      context "make error dut to lack of packages" do
        context "3 successful steps" do
          let(:dut_path) { "../examples/illigal_dut.vhd" }
          let(:test_proc) { Proc.new { |dut|
          } }

          it {
            expect(subject.result.compile_error?).to be_true
          }
        end
      end

      context "make success in any order" do
        context "entity after library it depending on" do
          let(:dut_path) { "../examples/datapath.vhd" }
          let(:test_proc) { Proc.new { |dut|
            dependencies "../examples/state_machine_lib.vhd",
              "../examples/state_machine.vhd"

            ports dut.input, dut.output
            clock dut.clk

            step 3, "STATE_A"
            step 1, "STATE_B"
            step 0, "STATE_C"
          } }

          it {
            expect(subject.result.succeeded?).to be_true
            expect(subject.steps.length).to eq(3) 
          }
        end

        context "entity before library it depending on" do
          let(:dut_path) { "../examples/datapath.vhd" }
          let(:test_proc) { Proc.new { |dut|
            dependencies "../examples/state_machine.vhd",
            "../examples/state_machine_lib.vhd"

            ports dut.input, dut.output
            clock dut.clk

            step 3, "STATE_A"
            step 1, "STATE_B"
            step 0, "STATE_C"
          } }

          it {
            expect(subject.result.succeeded?).to be_true
            expect(subject.steps.length).to eq(3) 
          }
        end
      end
    end
  end
end
