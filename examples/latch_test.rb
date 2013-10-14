LatchTest.dsl do
  assign :a, :output
  clock :clk

  step 1, 1
  step 2, 2
end
