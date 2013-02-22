library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga is
	port (
		CLK	: in std_logic;
		
		LED	: out std_logic_vector(7 downto 0);
		
		IRGB	: in std_logic_vector(7 downto 0);
		RGB	: out std_logic_vector(7 downto 0);
		
		W	: out std_logic;
		X	: out std_logic_vector(9 downto 0);
		Y	: out std_logic_vector(9 downto 0);
		
		HS		: out std_logic;
		VS		: out std_logic
	);
end vga;

architecture Behavioral of vga is
	signal horiz			: std_logic_vector(9 downto 0);
	signal vert				: std_logic_vector(9 downto 0);
begin

process (CLK) begin
	if CLK'event and CLK = '1' then
		-- 144 and 784
		if (horiz >= 146) and (horiz < 788)
		-- 39 and 519
		and (vert >= 32) and (vert < 519) then
			W <= '1';
			RGB <= IRGB;
			X <= horiz - 144 + 1;
			Y <= vert - 39 + 1;
		else
			W <= '0';
			RGB <= "11100011";
		end if;
		
		if (horiz > 0) and (horiz < 97) then
			HS <= '0';
		else
			HS <= '1';
		end if;
		
		if (vert > 0) and (vert < 3) then
			VS <= '0';
		else
			VS <= '1';
		end if;
		
		horiz <= horiz + 1;
		if (horiz = 800) then
			vert <= vert + 1;
			horiz <= (others => '0');
		end if;
		
		if (vert = 521) then
			vert <= (others => '0');
		end if;
	end if;
end process;

end Behavioral;

