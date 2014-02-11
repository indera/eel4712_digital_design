-- University of Florida
-- 
-- Multiply + Add: example sequential circuit
-- 
-- @author: Andrei Sura

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mult_add is
   generic( width: positive := 16);

   port (
      clk      : in std_logic;
      rst      : in std_logic;
      input1   : in std_logic_vector(width-1 downto 0);
      input2   : in std_logic_vector(width-1 downto 0);
      input3   : in std_logic_vector(width-1 downto 0);
      output   : out std_logic_vector(width-1 downto 0)
   );

end mult_add;

-- === BHV
architecture BHV of mult_add is
   signal mult_reg   : std_logic_vector(width-1 downto 0);
   signal input3_reg : std_logic_vector(width-1 downto 0);
  
begin
   process (clk, rst)
		-- store the multiplication result into a variable
		variable mult_res : unsigned(2*width-1 downto 0);
 
	begin
      if (rst = '1') then
         output <= (others => '0');
      elsif (rising_edge(clk)) then
			-- assignment of the signal on a rising edge
			-- synthesizes as a register
         mult_res := unsigned(input1) * unsigned(input2);
			
			-- keep only the lower half of the multiplication result
         mult_reg <= std_logic_vector( mult_res(width-1 downto 0));
			
			-- the last input is stored in a register before the add stage
         input3_reg <= input3;

         output <= std_logic_vector(unsigned(mult_reg) + unsigned(input3_reg));
      end if;
   end process;
end BHV;
 

