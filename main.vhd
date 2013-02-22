library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
	port (
		CLK : in std_logic;
		
		LED : out std_logic_vector(7 downto 0);
		RGB : out std_logic_vector(7 downto 0);
		
		HS  : out std_logic;
		VS  : out std_logic
	);
end main;

architecture Behavioral of main is
	component vga is
		port (
			CLK : in std_logic;
			
			LED : out std_logic_vector(7 downto 0);
			
			IRGB : in std_logic_vector(7 downto 0);
			
			RGB : out std_logic_vector(7 downto 0);
			
			W : out std_logic;
			X : out std_logic_vector(9 downto 0);
			Y : out std_logic_vector(9 downto 0);
			
			VS : out std_logic;
			HS : out std_logic
		);
	end component;
	
	signal inrgb : std_logic_vector(7 downto 0) := "00000000";
	
	signal w : std_logic;
	signal x : std_logic_vector(9 downto 0);
	signal y : std_logic_vector(9 downto 0);
begin

	VGADriver : component vga port map (
		CLK => CLK,
		LED => LED,
		HS => HS,
		VS => VS,
		RGB => RGB,
		IRGB => inrgb,
		W => w,
		X => x,
		Y => y
	);

	process (CLK) begin
		if w = '1' then
			if x >= 300 and x <= 340 and y >= 220 and y <= 260 then
				inrgb <= "11100011";
			else
				inrgb <= "00011100";
			end if;
		end if;
	end process;

end Behavioral;

