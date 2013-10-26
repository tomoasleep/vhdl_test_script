library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity register_file is

  port (
    input  : in  std_logic_vector(2 downto 0);
    update : in std_logic;
    output  : out std_logic_vector(2 downto 0);
    reg  : out std_logic_vector(2 downto 0);
    calc_result: out std_logic_vector(2 downto 0);
    clk : in  std_logic
    );

end register_file;

architecture behave of register_file is
  component calculator port(
    input : in std_logic_vector(2 downto 0);
    output : out std_logic_vector(2 downto 0));
  end component;
  signal data : std_logic_vector(2 downto 0);
  signal clout : std_logic_vector(2 downto 0);
begin  -- behave
  cl :calculator port map (
    input => input,
    output => clout);

  main: process(clk) begin
    if rising_edge(clk) then
      if update = '1' then
        data <= input;
        calc_result <= clout;
      end if;
    end if;
  end process;
  output <= input;
  reg <= data;
end behave;
