-- Packages
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

-- Entity 
entity bcd_counter is
	 generic (
            N :  std_logic_vector:=x"5F5E0FF"; -- count from 0 to M-1
            M : integer := 26   -- M bits required to count upto N i.e. 2**M >= N
    );
    
    Port ( clk_in : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           sseg : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end bcd_counter;

-- Architecture
architecture cntr_arch of bcd_counter is
     signal temp: std_logic_vector(0 to 3);
	  signal one_sec_counter: std_logic_vector(M downto 0);
	  signal one_sec_en: std_logic;
	  signal bcd: std_logic_vector(3 downto 0);
begin
		-- One second Pulse or tick
		process(clk_in,rst)
		begin
				if rst='1' then 
						one_sec_counter <= (others=>'0');
				elsif rising_edge(clk_in) then
						if one_sec_counter=N then
								one_sec_counter <= (others=>'0');
						else 
								one_sec_counter <= one_sec_counter +"1";
						end if;
				end if;
		end process;
		one_sec_en <= '1' when one_sec_counter=N else '0';
	   
		-- BCD counter
		process(clk_in,rst)
		begin
				if rst='1' then
						bcd<=(others=>'0');
				elsif rising_edge(clk_in) then
						if one_sec_en='1' then 
								if bcd="1001" then
										bcd<=(others=>'0');
								else
										bcd<=bcd +"1";
								end if;
						end if;
				end if;
		end process;
		
		-- Seven Segment display
		an<="1110";
		with bcd select
				sseg(6 downto 0)<=
						--abcdefg
						"0000001" when "0000",                       --0
						"1001111" when "0001",                       --1
						"0010010" when "0010" ,                      --2
						"0000110" when "0011",                       --3
						"1001100" when "0100" ,                      --4
						"0100100" when "0101",                       --5
						"0100000" when "0110" ,                      --6
						"0001111" when "0111",                       --7
						"0000000" when "1000" ,                      --8
						"0000100" when "1001",                       --9
						"0001000" when "1010" ,                      --A
						"1100000" when "1011",                       --B
						"0110001" when "1100",                       --C
						"1000010" when "1101" ,                      --D
						"0110000" when "1110",                       --E
						"0111000" when others;                        --F
			sseg(7) <= '0';
end cntr_arch;

