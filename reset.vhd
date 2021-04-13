LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

	ENTITY reset_module IS
	-- Generic ( M= )   -- uncomment the generic section and declare a value 
  	PORT(
		reset    : IN  STD_LOGIC; 
		counter  : OUT STD_LOGIC_VECTOR(M downto 0)        -- assign the generic value to the counter size 
	    );
		
	END reset_module;

	ARCHITECTURE arch_reset_module OF reset_module IS

	 	If(reset = '1') THEN             --reset counter because input is changing
                	
			counter <= (OTHERS => '0');   
		
 		end if;	
			
  	END arch_reset_module;
