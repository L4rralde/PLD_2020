library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_STD.ALL; 

entity seconds is
    Port ( clk : in  STD_LOGIC;
           oneSecond : out  STD_LOGIC);
end seconds;

architecture Behavioral of seconds is
	signal div : STD_LOGIC_VECTOR(12 downto 0); 
	signal pre : STD_LOGIC_VECTOR(18 downto 0); 
	signal localClk : STD_LOGIC; 

begin
	preDiv : process(clk) 
	begin
		if(rising_edge(clk)) then 
			pre <= pre+1; 
		end if; 
	end process; 

	localClk <= pre(18); 

	process(localClk)
	begin 
		if(rising_edge(localClk)) then 
			div <= ('0'&div(11 downto 0))+43; 
		end if; 
	end process;

	oneSecond <= div(12); 

end Behavioral;

