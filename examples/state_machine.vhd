library ieee;
use ieee.std_logic_1164.all;

library work;
use work.const_state.all;
use work.const_order.all;

-- DOCTEST DEPENDENCIES: state_machine_lib.vhd

entity state_machine is
  port(
        input: in std_logic;
        reset: in std_logic;

        state: out std_logic_vector(2 downto 0);
        clk : in std_logic
      );
end state_machine;

architecture behave of state_machine is
  signal current_state: std_logic_vector(2 downto 0);
begin
  main: process(clk) begin
    if rising_edge(clk) then
      case reset is
        when '1' =>
          current_state <= STATE_A;
        when others =>

          case current_state is
            when STATE_A =>
              current_state <= STATE_B;

            when STATE_B =>
              case input is
                when ORDER_A =>
                  current_state <= STATE_C;
                when others =>
                  current_state <= STATE_A;
              end case;

            when STATE_C =>
              case input is
                when ORDER_B =>
                  current_state <= STATE_D;
                when others =>
                  current_state <= STATE_A;
              end case;

            when STATE_D =>
              current_state <= STATE_A;
            when others =>
              current_state <= STATE_A;

          end case;
      end case;
    end if;
  end process;

  state <= current_state;
end behave;

