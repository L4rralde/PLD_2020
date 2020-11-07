library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_STD.ALL; 

entity BAUDGEN is
    Port ( CLK : in  STD_LOGIC;
           div : in  STD_LOGIC_VECTOR (7 downto 0);
           bauds : inout  STD_LOGIC);
end BAUDGEN;

architecture Behavioral of BAUDGEN is
	signal reg : STD_LOGIC_VECTOR(9 downto 0); 
	signal matchdiv : STD_LOGIC_VECTOR(7 downto 0); 
	signal res: STD_LOGIC; 
begin
	process(CLK) is
	begin
		if(rising_edge(CLK)) then 
--			reg <=("0" & reg((divlen + 4) downto 0)) + ("00000" & div);
			reg <=("0" & reg(8 downto 0)) + 151; 	--reg(9)_freq = CLK*0.2949218875
		end if; 
	end process; 

	process(reg(9), res) is
	begin 
		if(res = '1') then 
			matchdiv <= "00000000"; 
		elsif(rising_edge(reg(9))) then 
			matchdiv <= matchdiv+1; 
		end if; 
	end process; 

	match : process(matchdiv, div, reg(9)) is
	begin 	
		if(rising_edge(reg(9))) then 
			if(matchdiv = div) then 
				bauds <= not(bauds); --Bauds_freq = CLK*(0.2949218875)/(2*(div+1))= CLK*0.147746094375/(div+1)
				res <= '1'; 
			else 
				res <= '0'; 
			end if; 
		end if; 
	end process; 
end Behavioral;
