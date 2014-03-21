library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.VGA_LIB.all;

entity vga_tb is
end vga_tb;

architecture TB of vga_tb is

  -- MODIFY TO MATCH YOUR TOP LEVEL
  component vga
    port ( clk              : in  std_logic;
           rst              : in  std_logic;
           buttons_n        : in  std_logic_vector(2 downto 0);
           red, green, blue : out std_logic_vector(3 downto 0);
           h_sync, v_sync   : out std_logic);
  end component;

  signal clk              : std_logic := '0';
  signal rst              : std_logic := '1';
  signal buttons_n        : std_logic_vector(2 downto 0);
  signal red, green, blue : std_logic_vector(3 downto 0);
  signal h_sync, v_sync   : std_logic;

begin  -- TB

  -- MODIFY TO MATCH YOUR TOP LEVEL
  UUT : vga port map (
    clk       => clk,
    rst       => rst,
    buttons_n => buttons_n,
    red       => red,
    green     => green,
    blue      => blue,
    h_sync    => h_sync,
    v_sync    => v_sync);


  clk <= not clk after 10 ns;

  process
  begin

    buttons_n <= (others => '1');
    rst       <= '1';
    wait for 200 ns;

    buttons_n(TOP_LEFT) <= '0';
    rst                 <= '0';
    wait;

	-- ADD YOUR OWN TESTS
	
  end process;

end TB;
