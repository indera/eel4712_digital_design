-- University of Florida
-- 
-- Lab6: Testbench for the vga sync generator entity
-- 
-- @author: Andrei Sura

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- The entity
entity vga_sync_gen_tb is
end vga_sync_gen_tb;

-- 
architecture proc of vga_sync_gen_tb is
  -- inputs
  signal clk        :  std_logic := '0';
  signal rst        :  std_logic := '1'; -- start with no reset
  
  -- outputs
  signal hcount     : std_logic_vector(9 downto 0);
  signal vcount     : std_logic_vector(9 downto 0);
  signal horiz_sync : std_logic;
  signal vert_sync  : std_logic;
  signal video_on   : std_logic;

begin

UUT : entity work.vga_sync_gen
 port map (
      clk         => clk,
      rst         => rst,
      -- -----------------------
      hcount      => hcount,
      vcount      => vcount,
      horiz_sync  => horiz_sync,
      vert_sync   => vert_sync,
      video_on    => video_on
   );

  clk <= not clk after 20 ns;

  process
    begin
      rst <= '1';
      wait until clk'event and clk = '1';
      wait until clk'event and clk = '1';
      rst <= '0';

      report "Done Sumulating!";
      wait;
  end process;
end proc;
