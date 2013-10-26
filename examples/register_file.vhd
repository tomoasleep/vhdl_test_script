library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity register_file is

  port (
    input  : in  std_logic_vector(2 downto 0);
    update : in std_logic;
    output  : out std_logic_vector(2 downto 0);
    reg  : out std_logic_vector(2 downto 0);
    clk : in  std_logic
    );

end register_file;

architecture behave of register_file is
begin  -- behave

  main: process(clk) begin
    if rising_edge(clk) and update = '1' then
      reg <= input;
    end if;
  end process;
  output <= input;
end behave;
