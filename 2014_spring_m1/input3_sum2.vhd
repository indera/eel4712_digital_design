-- University of Florida
-- 
-- Add 3 inputs to produce 2 sums: example sequential circuit
-- 
-- @author: Andrei Sura

--     in1         in2        in3
--      |           |          |
--      V           V          | 
--    +-----+    +-----+       |
--    | Reg |    | Reg |       |
--    +-----+    +-----+       |
--      |          | |         |
--      |  +-------+ +------+  |
--      |  |                |  |
--      V  V                V  V
--      ___                 ___   
--     /   \               /   \ 
--    |  +  |             |  +  |
--     \___/               \___/ 
--       |                   |
--       |                   V
--       |                +-----+
--       |                | Reg |
--       |                +-----+
--       |                   |
--       V                   V
--      out1                out2
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input3_sum2 is
   generic(
      width: positive:= 116
   );
   port(
      clk, rst       : in std_logic;
      in1, in2, in3  : in std_logic_vector(width-1 downto 0);
      out1, out2     : out std_logic_vector(width-1 downto 0)
   );

end input3_sum2;


architecture BHV of input3_sum2 is
   signal in1_reg, in2_reg: std_logic_vector(width-1 downto 0);

begin
   process(clk, rst)
   begin
      if (rst = '1') then

         -- (!) Do not reset out1 since it is not the output of a register
         -- and the synthesis fails: Error (10028): Can't resolve multiple constant drivers for net "out1"

         out2 <= (others => '0');
         in1_reg <= (others => '0');
         in2_reg <= (others => '0');

      elsif (rising_edge(clk)) then
         in1_reg <= in1;
         in2_reg <= in2;

         -- A solution using a temp variable for the sum works too
         -- temp := in2_reg + in3;
         -- out2 <= temp; 
         out2 <= std_logic_vector(unsigned(in2_reg) + unsigned(in3));
      end if;

   end process;

   out1 <= std_logic_vector( unsigned(in1_reg) + unsigned(in2_reg));

end BHV;

