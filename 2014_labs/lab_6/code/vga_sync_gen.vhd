-- University of Florida
-- 
-- Lab6: VGA Synchorinaztion Generator
-- 
-- @author: Andrei Sura

library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.VGA_LIB.all; 


entity vga_sync_gen is 
   port (
      clk         : in std_logic;
      rst         : in std_logic;
      -- -----------------------
      hcount      : out std_logic_vector (9 downto 0);
      vcount      : out std_logic_vector (9 downto 0);
      horiz_sync  : out std_logic;
      vert_sync   : out std_logic;
      video_on    : out std_logic
   );
end vga_sync_gen;


architecture BHV of vga_sync_gen is
	-- constant C_ZERO : unsigned := to_unsigned(0, 10);

   -- Declare signals used internally by the process
   signal s_hcount      : std_logic_vector(9 downto 0);
   signal s_vcount      : std_logic_vector(9 downto 0);

   signal s_horiz_sync : std_logic;
   signal s_vert_sync  : std_logic;

   signal s_horiz_on    : std_logic;   -- use two extra signals for simpler logic
   signal s_vert_on     : std_logic;


begin -- arch
   -- s_video_on <= s_horiz_on AND s_vert_on;

   process (clk, rst)

   -- http://www.epanorama.net/documents/pc/vga_timing.html
   -- 
   -- "VGA industry standard" 640x480 pixel mode
   -- == General characteristics 
   --    Clock frequency 25.175 MHz
   --    Line frequency 31469 Hz
   --    Field frequency 59.94 Hz
   --
   -- == One line
   --    8 pixels front porch
   --    96 pixels horizontal sync
   --    40 pixels back porch
   --    8 pixels left border
   --    640 pixels video
   --    8 pixels right border
   -- ------------------------
   --    800 pixels total per line
   -- 
   -- == One field
   --    2 lines front porch
   --    2 lines vertical sync
   --    25 lines back porch
   --    8 lines top border
   --    480 lines video
   --    8 lines bottom border
   -- ------------------------- 
   --    525 lines total per field

   -- counts up to: 800 * 525 * 59.94 = 25174800 ~ 25.175 MHZ 
   -- variable count : integer range 0 to 25175000;

   begin 
      if (rst = '1') then
         -- count       :=  0;
         s_hcount    <= (others => '0');     
         s_vcount    <= (others => '0');

         s_horiz_sync <= '1';
         s_vert_sync  <= '1';

         s_horiz_on   <= '0';
         s_vert_on    <= '0';

         hcount <= (others => '0');
         vcount <= (others => '0');
         
         horiz_sync <= '1';
         vert_sync <= '1';

      elsif rising_edge(clk) then 
         -- ---------------------------
         -- Horizontal Sync calculation
         if (s_hcount = H_MAX) then
            s_hcount <= (others => '0');
         else
            s_hcount <= s_hcount + 1;
         end if;


         if (s_hcount >= HSYNC_BEGIN) AND ( s_hcount <= HSYNC_END) then  
            -- When inside `hsync_begin : hsync_end` range enable hsync
            s_horiz_sync <= '0';
         else 
            s_horiz_sync <= '1';
         end if;
         -- -------------- END hsync

         -- -------------------------
         -- Vertical Sync calculation
         if (s_vcount >= V_MAX) AND (s_hcount >= H_VERT_INC) then
            s_vcount <= (others => '0');
         elsif (s_hcount = H_VERT_INC) then
            s_vcount <= s_vcount + 1;
         end if;

         if (s_vcount >= VSYNC_BEGIN) AND (s_vcount <= VSYNC_END) then
            s_vert_sync <= '0';
         else 
            s_vert_sync <= '1';
         end if;             
         -- -------------- END vsync

         -- ---------------------
         -- Counters
         if (s_hcount <= H_DISPLAY_END) then
            s_horiz_on <= '1';
            hcount <= s_hcount;
         else 
            s_horiz_on <= '0';
         end if;


         if (s_vcount <= V_DISPLAY_END) then 
            s_vert_on <= '1';
            vcount <= s_vcount;
         else 
            s_vert_on <= '0';
         end if;

         horiz_sync <= s_horiz_sync;
         vert_sync <= s_vert_sync;
         
      end if; -- end rising edge

   end process;

   video_on <= s_horiz_on AND s_vert_on;

end BHV;
