VhdlTestScript.scenario "./datapath.vhd" do |dut|
  s = use_mock :state_machine
  ports dut.input, dut.output, s.input, s.reset, s.state
  clock dut.clk

  step 1, 2, 1, 0, 2
  step 2, 1, 0, 1, 1
  step _, 1, 0, 1, 1
  step 3, 1, 1, 1, 1
end
