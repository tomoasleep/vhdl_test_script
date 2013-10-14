StateMachineTest.dsl do
  assign :input, :reset, :state
  clock :clk
  require_package "work.const_state", "work.const_order"

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
