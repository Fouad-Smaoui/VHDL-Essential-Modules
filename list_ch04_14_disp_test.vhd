-- Packages used 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- entity  
entity disp_mux_test is
   
   -- generic (
           -- buttons : integer := 4
           -- switches : integer :=8  
	   -- anodes : integer := 4            7 segment display anodes   ( 4 bit 7 segment  ) 
	   -- cathodes : integer := 8         7 segment display cathodes (abcdefg and DP) );
   -- uncomment the generic section to customize the number of buttons and switches, and the size of 7 segments  
   port(
      clk: in std_logic; -- clock input 
      btn: in std_logic_vector(buttons-1 downto 0); 
      sw: in std_logic_vector(switches-1 downto 0);
      an: out std_logic_vector(anodes-1 downto 0);
      sseg: out std_logic_vector(cathodes-1 downto 0)
   );
end disp_mux_test;
   
-- behavioral architecture 
architecture arch of disp_mux_test is
   signal d3_reg, d2_reg: std_logic_vector(7 downto 0);
   signal d1_reg, d0_reg: std_logic_vector(7 downto 0);
begin
   
   disp_unit: entity work.disp_mux   -- call the disp mux file 
      -- port mapping 
      port map(    
         clk=>clk, reset=>'0',
         in3=>d3_reg, in2=>d2_reg, in1=>d1_reg,
         in0=>d0_reg, an=>an, sseg=>sseg);
   
      
      -- registers for 4 led patterns
   process (clk)
   begin
      if (clk'event and clk='1') then  -- first test related to clock event (rising edge clock) 
         if (btn(3)='1') then  -- second testing if the button is pressed  
            d3_reg <= sw;     
         end if;
         if (btn(2)='1') then
            d2_reg <= sw;
         end if;
         if (btn(1)='1') then
            d1_reg <= sw;
         end if;
         if (btn(0)='1') then
            d0_reg <= sw;
         end if;
      end if;
   end process;
end arch;
