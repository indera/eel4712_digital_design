-- University of Florida
-- 
-- Lab6: Display 128x128 pixel image from ROM to a VGA display 
-- 
-- Note: uses a 14bit address ROM (16384 words)
-- @author: Andrei Sura


library ieee;
use ieee.std_logic_1164.all;

entity vga_128x128 is
   port (
      clk         : in std_logic;
      rst         : in std_logic;
      buttons_n   : in std_logic_vector(2 downto 0);
      -- ------------------------------------------------
      red, green, blue  : out std_logic_vector(3 downto 0);
      h_sync, v_sync    : out std_logic
   );
end vga_128x128;

architecture STR of vga_128x128 is
   signal s_pix_clk        : std_logic;
   signal s_hcount         : std_logic_vector(9 downto 0);
   signal s_vcount         : std_logic_vector(9 downto 0);
   signal s_video_on       : std_logic;

   signal s_rom_address    : std_logic_vector(13 downto 0);
   signal s_rom_on         : std_logic;
   signal s_mux_color_in   : std_logic_vector(13 downto 0);
   signal s_mux_color_out  : std_logic_vector(13 downto 0);


begin

U_CLK_DIV: entity work.clk_25MHZ 
   generic map (
      clk_in_freq  => 50000000,
      clk_out_freq => 25000000
      )

   port map(
      clk_in         => clk,
      rst            => rst,
      clk_out        => s_pix_clk
   );

U_VGA_SYNC_GEN: entity work.vga_sync_gen
   port map(
      clk   => s_pix_clk,
      rst   => rst,
      -- -------------------
      hcount      => s_hcount,
      vcount      => s_vcount,
      horiz_sync  => h_sync,
      vert_sync   => v_sync,
      video_on    => s_video_on 
   );

U_VGA_BLOCK_ADDRESS: entity work.vga_block_address_128x128
   port map (
      hcount   => s_hcount,
      vcount   => s_vcount,
      video_on => s_video_on,
      buttons  => buttons_n,
      -- ------------------
      rom_address => s_rom_address,
      rom_on      => s_rom_on
   );

U_VGA_ROM: entity work.vga_rom_128x128 
   port map (
      address  => s_rom_address,
      clock    => s_pix_clk,
      q        => s_mux_color_in
   );

U_VGA_MUX: entity work.vga_mux_14bit
   port map(
      black => (others => '0'), 
      color => s_mux_color_in,
      sel   => s_rom_on,
      -- ---------------
      output => s_mux_color_out
   );

red   <= s_mux_color_out(11 downto 8);
green <= s_mux_color_out(7  downto 4);
blue  <= s_mux_color_out(3  downto 0);


end STR;


