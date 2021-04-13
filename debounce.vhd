LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY debouncing_buttons IS
  -- GENERIC(counter_size  :  INTEGER :=20); -- uncomment the generic section to choose a counter size (20 bits gives 10.5ms with 100MHz clock)
  PORT(
		clk     : IN  STD_LOGIC;  --input clock
		button  : IN  STD_LOGIC;  --input signal to be debounced
		result  : OUT STD_LOGIC); --debounced signal
END debouncing_buttons;

ARCHITECTURE arch_debounce OF debounce IS
	  SIGNAL flipflops   : STD_LOGIC_VECTOR(1 DOWNTO 0); -- input flip flops
	  SIGNAL counter_set : STD_LOGIC;                    --synchronous reset to zero
	  SIGNAL counter_out : STD_LOGIC_VECTOR(counter_size DOWNTO 0) := (OTHERS => '0'); --counter output, depending on the counter size predefined on generic section
BEGIN

	counter_set <= flipflops(0) xor flipflops(1);   --determine when to start or when to reset the counter
  
  PROCESS(clk)
  BEGIN
		IF(rising_edge(clk)) THEN               
				
				flipflops(0) <= button;
				flipflops(1) <= flipflops(0);
				
				If(counter_set = '1') THEN                 		--reset counter because input is changing
						counter_out <= (OTHERS => '0');     
				ELSIF(counter_out(counter_size) = '0') THEN 	--stable input time is not yet met : we didn't reach the maximal counter size yet  
						counter_out <= counter_out + 1;
				ELSE                                        		--stable input time is met : we reached the maximal counter size 
						result <= flipflops(1);                 -- Q = D 
				END IF;    
		END IF;
  END PROCESS;
END arch_debounce;
