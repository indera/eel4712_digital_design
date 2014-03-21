-- University of Florida
-- 
-- Lab6: VGA helper mux to pass the 12 bit color image from ROM to the VGA
-- 
-- @author: Andrei Sura


library ieee;
use ieee.std_logic_1164.all;

entity vga_mux_14bit is
   port (
      black : in  std_logic_vector(13 downto 0);
      color : in  std_logic_vector(13 downto 0);
      sel   : in  std_logic;
      -- --------------------
      output : out std_logic_vector(13 downto 0));
end vga_mux_14bit;

architecture BHV of vga_mux_14bit is
begin
  with sel select
    output <=
      black when '0',
      color when others;
end BHV;

