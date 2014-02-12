-- University of Florida
-- 
-- Add 3 inputs: example sequential circuit
-- 
-- @author: Andrei Sura

--             --        +-----+          
--  in1 -->   /  \       |     |
--           | +  |  --> | Reg | 
--  in2 -->   \  /       |     |         --  
--             --        +-----+ -->    /  \ 
--                                     | +  |  --> output
--  in3 -->  +-----+     +-----+ -->    \  /  
--           |     |     |     |         -- 
--           | Reg | --> | Reg |      
--           |     |     |     | 
--           +-----+     +-----+
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity add_3_inputs is
   generic(
      width: positive:= 16
   ); 
   port(
      clk, rst       : in std_logic;
      in1, in2, in3  : in std_logic_vector(width-1 downto 0);
      output         : out std_logic_vector(width-1 downto 0)
   );

end add_3_inputs;


architecture BHV of add_3_inputs is
   signal reg_sum12, reg_in3_a, reg_in3_b: std_logic_vector(width-1 downto 0);
   
begin

   -- adds two inputs in a sequential block
   process(clk, rst) 
   begin
      
      if (rst = '1') then
         reg_sum12 <= (others => '0');
         reg_in3_a <= (others => '0');
         reg_in3_b <= (others => '0');
         
      elsif (rising_edge(clk)) then
         reg_sum12 <= std_logic_vector( unsigned(in1) + unsigned(in2));
         reg_in3_a <= in3;
         reg_in3_b <= reg_in3_a;
         
      end if;
   end process;


   -- adds the two signals from the sequential block
   output <= std_logic_vector( unsigned(reg_sum12) + unsigned(reg_in3_b) );
end BHV;

    
