
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity led_counter is
	-- GENERIC( counter_size  :  INTEGER :=20
	-- 	    LED_PATTERNS  : INTEGER :=8          --  refers to the number of LED 
	); -- uncomment the generic section to customize the counter size (20 bits gives 10.5ms with 100MHz clock) and the number of led patterns 
	           
    Port ( clk : in  STD_LOGIC;  -- clock input 
           btn : in  STD_LOGIC;  -- button input 
           led : out  STD_LOGIC_VECTOR (LED_PATTERNS-1 downto 0)); 
end led_counter;

-- structural vhdl architecture 
architecture arch_led_counter of led_counter is
		signal db_btn: std_logic;
		signal click_counter : std_logic_vector(LED_PATTERNS-1 downto 0):="00000000"; -- initialize the counter 
		component debounce is
	   port( clk : in std_logic;
				   button: in std_logic;
				   result  : out std_logic
				 );
		end component;
		
begin
    db_unit : entity work.debounce(arch_debounce)                      -- calling the debouncing program 
					generic map (counter_size => counter_size)   
					 port map
								( clk => clk,
								  button => btn,
								  result => db_btn
					 ); 	
				 
		process(clk, db_btn)
		begin 
			if (rising_edge(clk)) then
				if db_btn='1' then
						click_counter<= click_counter + "1";   -- increment our counter
				end if;
			end if;
		end process;
		
		led <= click_counter;           
		
end arch_led_counter;

