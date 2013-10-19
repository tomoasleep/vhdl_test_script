library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity datapath is

  port (
    input   : in  std_logic_vector(2 downto 0);
    clk : in  std_logic;
    output  : out std_logic_vector(2 downto 0)
    );

end datapath;

architecture behave of datapath is
  component state_machine
    port(
    input: in std_logic;
    reset: in std_logic;
    state  : out std_logic_vector(2 downto 0);
    clk : in  std_logic
        );
  end component;
begin  -- behave
  datapath port map (
  input => input,
  reset => '0',
  clk => clk,
  state => output);

end behave;

