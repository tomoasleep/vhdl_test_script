VhdlTestScript.scenario "./state_machine.vhd" do
  ports :input, :reset, :state
  clock :clk
  dependencies "./state_machine_lib.vhd"

  testcases = [
    ["ORDER_B", "STATE_B"],
    ["ORDER_A", "STATE_C"],
    ["ORDER_A", "STATE_A"],
    ["ORDER_A", "STATE_B"],
    ["ORDER_B", "STATE_A"],
    ["ORDER_A", "STATE_B"],
    ["ORDER_A", "STATE_C"],
    ["ORDER_B", "STATE_D"],
    ["ORDER_A", "STATE_A"]
  ]

  step "ORDER_A", 1, "STATE_A"

  testcases.each do |i|
    step i.first, 0, i.last
  end

end
