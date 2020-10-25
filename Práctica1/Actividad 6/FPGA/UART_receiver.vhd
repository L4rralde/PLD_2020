library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  
use IEEE.NUMERIC_STD.ALL; 

entity receiver is
    Port ( 
    	   clk : in  STD_LOGIC;
--    	   clkout : out STD_LOGIC; --debug only
           rx : in  STD_LOGIC;
           done : out  STD_LOGIC;
           data : out  STD_LOGIC_VECTOR (7 downto 0));
end receiver;

architecture Behavioral of receiver is

	type states is (IDLE, START, STOP, D0, D1, D2, D3, D4, D5, D6, D7); 
	signal currentS, nextS: states; 
	signal sample, mem : STD_LOGIC_VECTOR(2 downto 0) := "000"; 
	signal bauds, busySig : STD_LOGIC; 
	signal dataR : STD_LOGIC_VECTOR(7 downto 0); 

begin
	sampling : process(clk) is 
	begin
		if(rising_edge(clk)) then 
			sample <= sample + 1; 
		end if; 
	end process;

	pairing : process(mem, sample) is
	begin 
		if(sample = mem) then 
			bauds <= '1';
		else
			bauds <= '0'; 
		end if; 
	end process; 

	FSM : process(currentS, Rx, sample, dataR, bauds) is
	begin
		case(currentS) is 
			when IDLE => busySig <= '0'; 
				if(Rx='0') then 
					mem <= sample; 
					nextS <= START;
				else
					nextS <= IDLE;
				end if; 
			when START => busySig <= '0';  
				nextS <= D0; 
			when D0 => busySig <= '0';  
				nextS <= D1;
			when D1 => busySig <= '0';  
				nextS <= D2;
			when D2 => busySig <= '0';  
				nextS <= D3;
			when D3 => busySig <= '0';  
				nextS <= D4;
			when D4 => busySig <= '0';  
				nextS <= D5;
			when D5 => busySig <= '0';  
				nextS <= D6;
			when D6 => busySig <= '0';  
				nextS <= D7;
			when D7 => busySig <= '0';  
				nextS <= STOP;
				data <= dataR; 
			when STOP => busySig <= '1'; 
				nextS <= IDLE;
		end case; 
	 
	end process; 

	done <= busySig; 

	update : process(bauds, nextS) is
	begin 
		if(falling_edge(bauds)) then 
			currentS <= nextS; 
			dataR <= Rx&dataR(7 downto 1); 
		end if; 	
	end process; 
--	clkout <= bauds; --debug only 
	

end Behavioral;