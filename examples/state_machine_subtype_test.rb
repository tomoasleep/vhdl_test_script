VhdlTestScript.scenario "./state_machine_subtype.vhd" do
  ports :input, :reset, :state
  clock :clk
  dependencies "./state_machine_lib.vhd"

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

end
