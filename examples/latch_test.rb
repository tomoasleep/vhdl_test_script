VhdlTestScript.scenario "./latch.vhd" do
  ports :a, :output
  clock :clk

  step 1, 1
  step 2, 2
  step _, 2
  step 1, _
end
