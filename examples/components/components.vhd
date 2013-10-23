library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity state_machine is
  port(
        input: in std_logic;
        reset: in std_logic;
        state  : out std_logic_vector(2 downto 0);
        clk : in  std_logic
      );
end state_machine;

architecture behave of state_machine is
begin
  state(0) <= input;
  state(2 downto 1) <= reset & reset;
end behave;
