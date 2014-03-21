-- University of Florida
-- 
-- Lab6: VGA Synchorinaztion Generator
-- 
-- @author: Andrei Sura

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.VGA_LIB.all; 


entity vga_block_address is
   port (
      hcount      : in std_logic_vector (9 downto 0);
      vcount      : in std_logic_vector (9 downto 0);
      video_on    : in std_logic;
      -- ----------------------
      buttons     : in std_logic_vector(2 downto 0); 
      -- -----------------------
      rom_address : out std_logic_vector(11 downto 0);
      rom_on      : out std_logic 
   );
end vga_block_address;


architecture BHV of vga_block_address is
begin
   process (hcount, vcount, video_on, buttons)
	
   variable temp_hcount : unsigned (5 downto 0);
   variable temp_vcount : unsigned (5 downto 0);
	
   begin -- proc
      -- defaults
      rom_address <= (others => '0');
      rom_on <= '0';


      if ( (buttons) = TOP_LEFT) then
         -- button 0
         if (video_on = '1')
               AND ( (hcount) >= TOP_LEFT_X_START)
               AND ( (hcount) <= TOP_LEFT_X_END) 
               AND ( (vcount) >= TOP_LEFT_Y_START)
               AND ( (vcount) <= TOP_LEFT_Y_END) then 

				-- output <= std_logic_vector(SHIFT_RIGHT(unsigned(input1), 1));
            temp_hcount := SHIFT_RIGHT(unsigned(hcount) - TOP_LEFT_X_START, 1)(5 downto 0);
            temp_vcount := SHIFT_RIGHT(unsigned(vcount) - TOP_LEFT_Y_START, 1) (5 downto 0);
				rom_address <= std_logic_vector(temp_vcount) & std_logic_vector(temp_hcount); 				
            rom_on 		<= '1';
         else
            null;
         end if;

      elsif ( (buttons) = TOP_RIGHT) then
         -- button 1
         if (video_on = '1')
               AND (hcount >= TOP_RIGHT_X_START)
               AND (hcount <= TOP_RIGHT_X_END)
               AND (vcount >= TOP_RIGHT_Y_START)
               AND (vcount <= TOP_RIGHT_Y_END) then 

            temp_hcount := SHIFT_RIGHT( unsigned(hcount) - TOP_RIGHT_X_START, 1)(5 downto 0);
            temp_vcount := SHIFT_RIGHT( unsigned(vcount) - TOP_RIGHT_Y_START, 1)(5 downto 0);
				rom_address <= std_logic_vector(temp_vcount) & std_logic_vector(temp_hcount); 				
            rom_on 	<= '1';
         else
            null;
         end if;

      elsif ( (buttons) = BOTTOM_LEFT) then
         -- button 2
         if (video_on = '1')
               AND (hcount >= BOTTOM_LEFT_X_START)
               AND (hcount <= BOTTOM_LEFT_X_END) 
               AND (vcount >= BOTTOM_LEFT_Y_START)
               AND (vcount <= BOTTOM_LEFT_Y_END) then 

            temp_hcount := SHIFT_RIGHT( unsigned(hcount) - BOTTOM_LEFT_X_START, 1) (5 downto 0);
            temp_vcount := SHIFT_RIGHT( unsigned(vcount) - BOTTOM_LEFT_Y_START, 1) (5 downto 0);
            rom_address <= std_logic_vector(temp_vcount) & std_logic_vector(temp_hcount);
            rom_on 		<= '1';
         else
            null;
         end if;

      elsif ( (buttons) = BOTTOM_RIGHT) then
         -- button 3
         if (video_on = '1')
            AND (hcount >= BOTTOM_RIGHT_X_START)
            AND (hcount <= BOTTOM_RIGHT_X_END)
            AND (vcount >= BOTTOM_RIGHT_Y_START)
            AND (vcount <= BOTTOM_RIGHT_Y_END) then 

         temp_hcount := SHIFT_RIGHT( unsigned(hcount) - BOTTOM_RIGHT_X_START, 1) (5 downto 0);
         temp_vcount := SHIFT_RIGHT( unsigned(vcount) - BOTTOM_RIGHT_Y_START, 1) (5 downto 0);
			rom_address	<= std_logic_vector(temp_vcount) & std_logic_vector(temp_hcount); 
         rom_on 		<= '1';
      else
         null;
      end if;

      else 
         -- center image
         if (video_on = '1')
            AND (hcount >= CENTERED_X_START) 
            AND (hcount <= CENTERED_X_END)
            AND (vcount >= CENTERED_Y_START)
            AND (vcount <= CENTERED_Y_END) then 

         temp_hcount := SHIFT_RIGHT( unsigned(hcount) - CENTERED_X_START, 1) (5 downto 0);
         temp_vcount := SHIFT_RIGHT( unsigned(vcount) - CENTERED_Y_START, 1) (5 downto 0);
			rom_address <= std_logic_vector(temp_vcount) & std_logic_vector(temp_hcount); 
         rom_on 	   <= '1';
      else
         null;
      end if;
	end if;

   end process; 
end BHV;
