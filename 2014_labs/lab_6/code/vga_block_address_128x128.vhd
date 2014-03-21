-- University of Florida
-- 
-- Lab6: VGA Synchorinaztion Generator for a 128x128 image
-- 
-- @author: Andrei Sura

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.VGA_LIB.all; 


entity vga_block_address_128x128 is
   port (
      hcount      : in std_logic_vector (9 downto 0);
      vcount      : in std_logic_vector (9 downto 0);
      video_on    : in std_logic;
      -- ----------------------
      buttons     : in std_logic_vector(2 downto 0); 
      -- -----------------------
      rom_address : out std_logic_vector(13 downto 0);
      rom_on      : out std_logic 
   );
end vga_block_address_128x128;


architecture BHV of vga_block_address_128x128 is
   -- signal xyz : std_logic;
	
begin
   -- variable abc : std_logic
   process (hcount, vcount, video_on, buttons)

   variable temp_hcount : unsigned (6 downto 0);
   variable temp_vcount : unsigned (6 downto 0);
	
	variable temp_hinc : unsigned (6 downto 0);
	variable temp_h : unsigned (6 downto 0);

	variable temp_vinc : unsigned (6 downto 0);
	variable temp_v : unsigned (6 downto 0);
	
	
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

            temp_hcount := unsigned(unsigned(hcount) - TOP_LEFT_X_START) (6 downto 0);
            temp_vcount := unsigned(unsigned(vcount) - TOP_LEFT_Y_START) (6 downto 0);
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

            temp_hcount := unsigned( unsigned(hcount) - TOP_RIGHT_X_START) (6 downto 0);
            temp_vcount := unsigned( unsigned(vcount) - TOP_RIGHT_Y_START) (6 downto 0);
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

            temp_hcount := unsigned( unsigned(hcount) - BOTTOM_LEFT_X_START) (6 downto 0);
            temp_vcount := unsigned( unsigned(vcount) - BOTTOM_LEFT_Y_START) (6 downto 0);
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

         temp_hcount := unsigned( unsigned(hcount) - BOTTOM_RIGHT_X_START) (6 downto 0);
         temp_vcount := unsigned( unsigned(vcount) - BOTTOM_RIGHT_Y_START) (6 downto 0);
			rom_address	<= std_logic_vector(temp_vcount) & std_logic_vector(temp_hcount); 
         rom_on 		<= '1';
      else
         null;
      end if;

      else
			-- increment a counter every clock
			temp_hinc := temp_hinc + 1;
			
			-- attempt to reset 
			--if (temp_hinc > 200) then 
			--	temp_hinc := (others => '0');
			--end if;

			-- every 20 steps increment the horizontal position
			if (temp_hinc mod 20 = 0) then
				temp_h := temp_h + 1;
			end if;
			
         -- center image
         if (video_on = '1')
            AND (hcount >= CENTERED_X_START + to_integer(temp_h)) 
            AND (hcount <= CENTERED_X_END + to_integer(temp_h))
            AND (vcount >= CENTERED_Y_START)
            AND (vcount <= CENTERED_Y_END) then 

				
         temp_hcount := unsigned( unsigned( hcount) - (CENTERED_X_START + to_integer(temp_h))) (6 downto 0);
         temp_vcount := unsigned( unsigned(vcount) - CENTERED_Y_START) (6 downto 0);
			rom_address <= std_logic_vector(temp_vcount) & std_logic_vector(temp_hcount); 
         rom_on 	   <= '1';
      else
         null;
      end if;
	end if;

   end process; 
end BHV;
