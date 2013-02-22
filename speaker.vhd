library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- period of 25 MHz oscillator is 40 ns

entity speaker is
	port (
		CLK: in std_logic;
		
		HPERIOD: in std_logic_vector(24 downto 0);
		PLAY: in std_logic;
		
		PIN: out std_logic
	);
end speaker;

architecture Behavioral of speaker is
	
begin

	process (CLK)
		variable sout: std_logic := '0';
		variable prescaler: std_logic_vector(24 downto 0) := (others => '0');
	begin
		if CLK'event and CLK = '1' then
			if PLAY = '1' then
				if prescaler >= HPERIOD then
					sout := not sout;
					prescaler := (others => '0');
				end if;
				prescaler := prescaler + 1;
			else
				sout := '0';
				prescaler := (others => '0');
			end if;
		end if;
		PIN <= sout;
	end process;

end Behavioral;

