library ieee;
use ieee.std_logic_1164.all;

library work;
use work.const_state.all;
use work.const_order.all;
use work.const_state2.all;

-- DOCTEST DEPENDENCIES: state_machine_lib.vhd

entity state_machine is
  port(
        input: in std_logic;
        reset: in std_logic;

        state: out state_type;
        clk : in std_logic
      );
end state_machine;

architecture behave of state_machine is
  signal current_state: state_type;
begin
  main: process(clk) begin
    if rising_edge(clk) then
      case reset is
        when '1' =>
          current_state <= STATE_E;
        when others =>

          case current_state is
            when STATE_E =>
              current_state <= STATE_F;

            when STATE_F =>
              case input is
                when ORDER_A =>
                  current_state <= STATE_G;
                when others =>
                  current_state <= STATE_E;
              end case;

            when STATE_G =>
              case input is
                when ORDER_B =>
                  current_state <= STATE_H;
                when others =>
                  current_state <= STATE_E;
              end case;

            when STATE_H =>
              current_state <= STATE_E;
            when others =>
              current_state <= STATE_E;

          end case;
      end case;
    end if;
  end process;

  state <= current_state;
end behave;

