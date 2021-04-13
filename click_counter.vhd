
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity click_counter is
    Generic (counter_size  :  INTEGER :=20);
    Port ( clk : in  STD_LOGIC;
             btn : in  STD_LOGIC;
				 rst : in std_logic;
             led : out  STD_LOGIC_VECTOR (7 downto 0));
end click_counter;
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
  signal counter: std_logic_vector(7 downto 0):=(others=>'0');
  signal reg_state: unsigned(19 downto 0):=(others=>'0');
  signal reg_next: unsigned(19 downto 0):=(others=>'0');
  signal clk10ms: std_logic;
begin
	   db_unit: entity work.debounce(arch_debounce)
			generic map (counter_size=>counter_size)
			port map(
					clk => clk,
					button => btn,
					result => db_btn 
			);
		
		clock_10ms: process(clk, rst)
		begin 
			if rst='1' then
				reg_state<= (others=>'0');
			elsif clk'event and clk='1' then
				reg_state<=reg_next;
			end if;
		end process clock_10ms;
		reg_next <= reg_state+ 1;
		clk10ms <= '1' when reg_state=500000 else '0';
		
	   counter_process: process(clk,rst, clk10ms, db_btn )
		begin
		     if rst = '1' then 
					counter<= (others=>'0');
			 elsif clk'event and clk='1' then 
					if db_btn = '1'  and clk10ms='1' then 
							counter<= counter +'1';
					else 
						  counter <= counter + '0';
					end if;
			end if;
		end process counter_process;
		
		led <= counter;
end arch_click_counter;

