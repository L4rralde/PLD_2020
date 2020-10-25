library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity codificador_7s is
    Port ( cont : in  STD_LOGIC_VECTOR (3 downto 0);
           disp : out  STD_LOGIC_VECTOR (6 downto 0));
end codificador_7s;

architecture Behavioral of codificador_7s is

begin
	with cont select disp<=
		"0000001" when "0000",
		"1001111" when "0001",
		"0010010" when "0010", 
		"0000110" when "0011", 
		"1001100" when "0100", 
		"0100100" when "0101", 
		"0100000" when "0110", 
		"0001110" when "0111",
		"0000000" when "1000",
		"0000100" when "1001",
		"0001000" when "1010",
		"1100000" when "1011",
		"0110001" when "1100",
		"1000010" when "1101",
		"0110000" when "1110",
		"0111000" when "1111",
		"1111111" when others; 
end Behavioral;

