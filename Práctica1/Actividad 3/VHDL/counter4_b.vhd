library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 	
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter4_b is
    Port ( clk : in  STD_LOGIC;
           hab : in  STD_LOGIC;
           dir : in  STD_LOGIC;
           res : in  STD_LOGIC;
           cnt : out  STD_LOGIC_VECTOR (3 downto 0));
end counter4_b;

architecture contador of counter4_b is
	signal cont: STD_LOGIC_VECTOR(3 downto 0):=x"0"; 
begin
	process(clk, res, dir, hab, cont)
	begin 
		if(res = '0') then
			cont <= x"0"; 
		elsif (rising_edge(clk)) then
			if(hab = '1') then 
				if(dir = '1') then 
					cont <= cont+1; 
				else
					cont <= cont-1; 
				end if; 
			end if; 
		end if;  
	cnt <= cont; 
	end process; 

end contador;

