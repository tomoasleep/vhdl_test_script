library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- TEST
-- /TEST

entity latch is

  port (
    a       : in  std_logic_vector(2 downto 0);
    clk : in  std_logic;
    output  : out std_logic_vector(2 downto 0)
    );

end latch;

architecture behave of latch is

begin  -- behave

  main: process(clk) begin
    if rising_edge(clk) then
      output <= a;
    end if;
  end process;


end behave;
