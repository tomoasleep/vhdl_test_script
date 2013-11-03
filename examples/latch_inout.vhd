library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- TEST
-- /TEST

entity latch is

  port (
    data   : inout  std_logic_vector(2 downto 0);
    mem : out std_logic_vector(2 downto 0);
    clk : in  std_logic;
    we  : in std_logic
    );

end latch;

architecture behave of latch is
  signal reg : std_logic_vector(2 downto 0) := "000";
begin  -- behave

  main: process(clk) begin
    if rising_edge(clk) then
      case we is
        when '1' =>
          reg <= data;
        when others =>
      end case;

    end if;
  end process;
  
  data <= reg when we = '0' else (others => 'Z');
  mem <= reg;
end behave;
