
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity led_counter is
	GENERIC(counter_size  :  INTEGER :=20); --counter size (20 bits gives 10.5ms with 100MHz clock)
    Port ( clk : in  STD_LOGIC;
           btn : in  STD_LOGIC;
           led : out  STD_LOGIC_VECTOR (7 downto 0));
end led_counter;

architecture arch_led_counter of led_counter is
		signal db_btn: std_logic;
		signal click_counter : std_logic_vector(7 downto 0):="00000000";
		component debounce is
	   port( clk : in std_logic;
				   button: in std_logic;
				   result  : out std_logic
				 );
		end component;
		
begin
    db_unit : entity work.debounce(arch_debounce)
					generic map (counter_size => counter_size)
					 port map
								( clk => clk,
								  button => btn,
								  result => db_btn
					 ); 	
				 
		process(clk, db_btn)
		begin 
			if clk'event and clk='1' then
				if db_btn='1' then
						click_counter<= click_counter + "1";
				end if;
			end if;
		end process;
		
		led <= click_counter;
		
end arch_led_counter;

