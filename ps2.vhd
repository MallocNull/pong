library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PS2Driver is
	port (
		CLK: in std_logic;
		CLR: in std_logic;
		
		PS2C: in std_logic;
		PS2D: in std_logic;
		
		KEY: out std_logic_vector(15 downto 0)
	);
end PS2Driver;

architecture Behavioral of PS2Driver is

begin

end Behavioral;

