library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
	port (
		CLK : in std_logic;
		
		LED : out std_logic_vector(7 downto 0);
		
		POUT : out std_logic;
		
		RGB : out std_logic_vector(7 downto 0);
		
		HS  : out std_logic;
		VS  : out std_logic
	);
end main;

architecture Behavioral of main is
	component vga is
		port (
			CLK : in std_logic;
			
			IRGB : in std_logic_vector(7 downto 0);
			
			RGB : out std_logic_vector(7 downto 0);
			
			FRAME : out std_logic;
			W : out std_logic;
			X : out std_logic_vector(9 downto 0);
			Y : out std_logic_vector(9 downto 0);
			
			VS : out std_logic;
			HS : out std_logic
		);
	end component;
	
	component speaker is
		port (
			CLK: in std_logic;
			
			HPERIOD: in std_logic_vector(24 downto 0);
			PLAY: in std_logic;
			
			PIN: out std_logic
		);
	end component;
	
	signal son : std_logic := '0';
	signal hper : std_logic_vector(24 downto 0) := 	"0000000000110000000010010";
	
	signal inrgb : std_logic_vector(7 downto 0) := "00000000";
	
	signal fclk : std_logic;
	signal w : std_logic;
	signal x : std_logic_vector(9 downto 0);
	signal y : std_logic_vector(9 downto 0);
begin

	LED <= "00000000";

	SpeakerDriver : component speaker port map (
		CLK => CLK,
		
		HPERIOD => hper,
		PLAY => son,
		
		PIN => POUT
	);

	VGADriver : component vga port map (
		CLK => CLK,
		HS => HS,
		VS => VS,
		RGB => RGB,
		IRGB => inrgb,
		FRAME => fclk,
		W => w,
		X => x,
		Y => y
	);
	
	process (CLK, fclk)
		variable prescaler	: std_logic_vector(18 downto 0) 	:= (others => '0'); 
		
		variable ph				: signed(7 downto 0)					:= "00100000";
		variable lp				: signed(10 downto 0)				:= "00011110000";	
		variable rp				: signed(10 downto 0)				:= "00011110000";		
		
		variable cx 			: signed(10 downto 0)				:= "00101000000";
		variable cdx			: signed(5 downto 0)					:= "000100";
		variable cy				: signed(10 downto 0)				:= "00011110000";
		variable cdy			: signed(5 downto 0)					:= "000010";
		variable cw				: signed(7 downto 0)					:= "00001010";
	begin
		-- called at 60 Hz, handle game logic here
		if fclk'event and fclk = '1' then
			if cx-cw <= 0 or cx+cw >= 640 then
				prescaler := (others => '0');
				son <= '1';
				hper <= "0000000000111100000010010";
				
				cdx := -cdx;
			end if;
			
			if cy-cw <= 25 or cy+cw >= 455 then
				prescaler := (others => '0');
				son <= '1';
				hper <= "0000000000111100000010010";
				
				cdy := -cdy;
			end if;
			
			if cx-cw >= 50 and cx-cw <= 60 and (cy-cw >= lp-ph-cw and cy+cw <= lp+ph+cw) then
				prescaler := (others => '0');
				son <= '1';
				hper <= "0000000000110000000010010";
				
				cdx := -cdx;
			end if;
			
			if cx+cw >= 580 and cx+cw <= 590 and (cy-cw >= rp-ph-cw and cy+cw <= rp+ph+cw) then
				prescaler := (others => '0');
				son <= '1';
				hper <= "0000000000110000000010010";
				
				cdx := -cdx;
			end if;
			
			if cdx < 0 then
				if lp-cy > 0 then
					lp := lp-4;
				elsif lp-cy < 0 then
					lp := lp+4;
				end if;
			else
				if rp-cy > 0 then
					rp := rp-4;
				elsif rp-cy < 0 then
					rp := rp+4;
				end if;
			end if;
			
			if son = '1' then
				if prescaler >= 5 then
					son <= '0';
					prescaler := (others => '0');
				else
					prescaler := prescaler + 1;
				end if;
			end if;
			
			cx := cx + cdx;
			cy := cy + cdy;
		end if;
		
		-- called whenver drawing, handle graphic logic here
		if w = '1' then
			if (y >= 10 and y <= 20) or (y <= 470 and y >= 460) then
				inrgb <= "11111111";
			elsif  x >= 45 and x <= 60 and y >= lp-ph and y <= lp+ph then
				inrgb <= "11111111";
			elsif  x >= 580 and x <= 595 and y >= rp-ph and y <= rp+ph then
				inrgb <= "11111111";
			elsif x >= cx-cw and x <= cx+cw and y >= cy-cw and y <= cy+cw then
				inrgb <= "11111111";
			else
				inrgb <= "00000000";
			end if;
		end if;
	end process;

end Behavioral;

