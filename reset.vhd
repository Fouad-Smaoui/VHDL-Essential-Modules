LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reset_module IS
  PORT(
		reset    : IN  STD_LOGIC; 
		counter  : OUT STD_LOGIC);
END reset_module;
ARCHITECTURE arch_reset_module OF reset_module IS

				If(reset = '1') THEN                 					--reset counter because input is changing
                counter <= (OTHERS => '0');
 
  END arch_reset_module;
