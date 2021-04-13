
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity click_counter is
    --Generic (counter_size  :  INTEGER :=20
	   --  led_patterns  :  INTEGER := 8); uncomment this section for customizing the counter size and the number of led patterns 
    Port (   clk : in  STD_LOGIC; -- clock input 
             btn : in  STD_LOGIC; -- button input 
	     rst : in std_logic;  -- reset input 
             led : out  STD_LOGIC_VECTOR (led_patterns-1 downto 0));
end click_counter;
	-- structural vhdl architecture 
architecture arch_click_counter of click_counter is
    signal db_btn: std_logic;
		-- component declaration
		component debounce is
				port (
					clk     : IN  STD_LOGIC;  --input clock

					button  : IN  STD_LOGIC;  --input signal to be debounced

					result  : OUT STD_LOGIC
			 );
		 end component;
			
  signal counter: std_logic_vector(led_patterns-1 downto 0):=(others=>'0'); -- initialize our counter with value 0 
-- clock divider program 
  signal reg_state: unsigned(counter_size-1 downto 0):=(others=>'0');  
  signal reg_next: unsigned(counter_size-1 downto 0):=(others=>'0');
  signal clk10ms: std_logic; 
begin
	   db_unit: entity work.debounce(arch_debounce) -- call debouncing program 
			generic map (counter_size=>counter_size)
			port map(
					clk => clk,
					button => btn,
					result => db_btn 
			);
		-- clock divider part 
		clock_10ms: process(clk, rst)
		begin 
			if rst='1' then
				reg_state<= (others=>'0'); 
			elsif (rising_edge(clk)) then
				reg_state<=reg_next;
			end if;
		end process clock_10ms;
		reg_next <= reg_state+ 1;
		clk10ms <= '1' when reg_state=500000 else '0';       -- here you can customize the frequency of the clock by modifying the reg_state value 
		
		-- counting part 
	   counter_process: process(clk,rst, clk10ms, db_btn )
		begin
		     if rst = '1' then 
					counter<= (others=>'0');
			 elsif (rising_edge(clk)) then 
					if db_btn = '1'  and clk10ms='1' then      -- here we added the clock divider condition 
							counter<= counter +'1';    
					else 
						  counter <= counter + '0';
					end if;
			end if;
		end process counter_process;
		
		led <= counter;
end arch_click_counter;

