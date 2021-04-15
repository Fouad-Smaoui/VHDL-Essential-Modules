-- Packages
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity 
entity disp_mux is
-- generic (
           -- X : integer :=8           inputs of X bits 
	   -- anodes : integer :=4            7 segment display anodes   ( 4 bit 7 segment  ) 
	   -- cathodes : integer := 8         7 segment display cathodes (abcdefg and DP) 
    ); -- uncomment the generic section to customize the size M and the N ( which is M-1 ) value where the counting should restart 
   port(
      
      clk, reset: in std_logic; -- input clock and reset 
      in3, in2, in1, in0: in std_logic_vector(X-1 downto 0); -- our 4 inputs ( as switches or buttons ) 
      an: out std_logic_vector(anodes-1 downto 0);
      sseg: out std_logic_vector(cathodes-1 downto 0)
   );
end disp_mux ;

   
--behavioral architecture 
architecture arch of disp_mux is
   
   -- refreshing rate around 800 Hz (50MHz/2^16)
   constant N: integer:=18;

   signal q_reg, q_next: unsigned(N-1 downto 0);
   signal sel: std_logic_vector(1 downto 0);  -- mux select signal 
begin
  
   -- register sub program 
   process(clk,reset)
   begin
      if reset='1' then
         q_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         q_reg <= q_next;
      end if;
   end process;
         
   -- next-state logic for the counter
   q_next <= q_reg + 1;

      -- multiplexing subprogram 
   sel <= std_logic_vector(q_reg(N-1 downto N-2)); --  use of 2 MSBs of counter to control 4-to-1 multiplexing and to generate active-low enable signal
   process(sel,in0,in1,in2,in3)
   begin
      case sel is
         when "00" =>
            an <= "1110";
            sseg <= in0;
         when "01" =>
            an <= "1101";
            sseg <= in1;
         when "10" =>
            an <= "1011";
            sseg <= in2;
         when others =>
            an <= "0111";
            sseg <= in3;
      end case;
   end process;
end arch;
