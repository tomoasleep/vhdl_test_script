library ieee;
use ieee.std_logic_1164.all;

package const_state is
      constant STATE_A       : std_logic_vector(2 downto 0) := "000";
      constant STATE_B       : std_logic_vector(2 downto 0) := "001";
      constant STATE_C       : std_logic_vector(2 downto 0) := "010";
      constant STATE_D       : std_logic_vector(2 downto 0) := "011";
end const_state;

library ieee;
use ieee.std_logic_1164.all;

package const_order is
      constant ORDER_A       : std_logic := '0';
      constant ORDER_B       : std_logic := '1';
end const_order;

library ieee;
use ieee.std_logic_1164.all;

package const_state2 is
      subtype state_type   is std_logic_vector(2 downto 0);
      constant STATE_E       : state_type := "000";
      constant STATE_F       : state_type := "001";
      constant STATE_G       : state_type := "010";
      constant STATE_H       : state_type := "011";
end const_state2;
