-- University of Florida
-- 
-- Lab6: Generic Clock Divider
-- 
-- @author: Andrei Sura


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


-- Expected waveform for a 4:1 divider
--           ---     ---     ---     ---     ---
-- clk_in   |   |___|   |___|   |___|   |___|   |______ ...
--
--           ---------------  1, 2            --------- ...
-- clk_out  | 1, 2          |________________|
--
-- 
--  FREQ_RATIO = clk_in/clk_out <= 2^n_bits

entity clk_div is
   generic(clk_in_freq : natural; -- := 4;
          clk_out_freq : natural -- := 1
			 );
   port (
      clk_in     : in  std_logic;
      rst        : in  std_logic;
      -- -----------------------
      clk_out    : out std_logic 
   );
end clk_div;

-- implementation
architecture CLK_DUTY_DIV of clk_div is

   -- In the worst case scenario we need to divide an input
   -- frequency F_IN by itself so we need a counter with enough
   -- bits to represent the F_IN number in binary.
   -- To obtain the number of bits necessary we do log2(F_IN)

   constant FREQ_RATIO     : natural := clk_in_freq/clk_out_freq;
   constant COUNTER_WIDTH  : integer := integer(ceil(log2( real(FREQ_RATIO))));

   signal counter          : unsigned(COUNTER_WIDTH - 1 downto 0);
   signal clk_out_temp     : std_logic;  -- the one bit that represents the slower clock

begin -- arch
   process (clk_in, rst) begin

      if (rst = '1') then
         counter        <= (others => '0');
         clk_out_temp   <= '0';

      elsif rising_edge(clk_in) then 

         -- if we reached the half of the ratio we need to invert the signal 
         if ( counter = ( integer(FREQ_RATIO/2) - 1 )) then
            clk_out_temp	<= NOT(clk_out_temp);
            counter        <= (others => '0');

         else
            counter <= counter + 1;
         end if;               
      end if;
   end process;

    -- set the output signal
   clk_out <= clk_out_temp;

end CLK_DUTY_DIV;

