VhdlTestScript.scenario "./latch.vhd", :x do
  ports :a, :output
  clock :clk

  context "should pass" do
    step 1, 1
    step 2, 2
    step _, 2
    step 1, _
  end
end

VhdlTestScript.scenario "./latch.vhd", :x, :y do
  ports :a, :output
  clock :clk

  context "should fail" do
    step 1, 2
  end
end

VhdlTestScript.scenario "./latch.vhd", :y do
  ports :a, :output
  clock :clk

  context "should pass and fail" do
    step 1, 2
    step _, 1
  end
end
