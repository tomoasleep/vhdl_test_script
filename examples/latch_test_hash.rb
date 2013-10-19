VhdlTestScript.scenario "./latch.vhd" do
  ports :a, :output
  clock :clk

  step a: 1, output: 1
end
