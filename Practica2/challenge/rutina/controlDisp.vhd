  
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity controlDisp is
port(
	CLK : in STD_LOGIC; 
	byte_in : in STD_LOGIC_VECTOR(3 downto 0); 
	AN : out STD_LOGIC_VECTOR(3 downto 0) := "1111"; 
	DISPLAY : out STD_LOGIC_VECTOR(7 downto 0)
); 
end controlDisp;

architecture Behavioral of controlDisp is
	signal UNI, DEC, CEN, MIL: STD_LOGIC_VECTOR(3 downto 0); 
	signal SEL : STD_LOGIC_VECTOR(1 downto 0); 
	signal D : STD_LOGIC_VECTOR(3 downto 0);
	signal contadors : integer range 1 to 6250 := 1; 
	signal SAL_250us : STD_LOGIC;  

begin

	turning : process(clk, byte_in) is 
	begin 
		if(rising_edge(CLK)) then 
			if(byte_in(3)='1') then 
				MIL <= "1000"; 
				CEN <= "0000"; 
				DEC <= "1001"; 
				UNI <= "1000"; 
			else
				MIL <= '0'&(byte_in(2 downto 0)); 
				CEN <= "0000"; 
				DEC <= "1111"; 
				UNI <= "1111"; 
			end if; 
		end if; 
	end process; 

	div2250us : process(CLK) 
	begin 
		if rising_edge(CLK) then
			if (contadors = 6250) then --cuenta 0.125ms (50MHz=6250)
				-- if (contadors = 12500) then --cuenta 0.125ms (100MHz=12500)
				SAL_250us <= NOT(SAL_250us); --genera un barrido de 0.25ms
				contadors <= 1;
			else
				contadors <= contadors+1;
			end if;
		end if;
	end process; 

	disp_sel : process(SAL_250us, SEL, UNI, DEC, CEN, MIL)
	begin 
		if(rising_edge(SAL_250us)) then 
			SEL <= SEL+1; 
			case(SEL) is 
				when "00" => AN <="0111"; D <= UNI; -- UNIDADES
				when "01" => AN <="1011"; D <= DEC; -- DECENAS
				when "10" => AN <="1101"; D <= CEN; -- CENTENAS
				when "11" => AN <="1111"; D <= MIL; -- MILLARES
				
				when OTHERS => AN <="1111"; -- OFF
			end case; 
		end if; 
	end process;

	decod_BCD27seg : process(D)
	begin 	
		case(D) is 
			when "0000" => DISPLAY <= "00000011"; --0
			when "0001" => DISPLAY <= "10011111"; --1
			when "0010" => DISPLAY <= "00100101"; --2
			when "0011" => DISPLAY <= "00001101"; --3
			when "0100" => DISPLAY <= "10011001"; --4
			when "1001" => DISPLAY <= "11010101"; --n			
			when "1111" => DISPLAY <= "01110001"; --F
			when OTHERS => DISPLAY <= "11111111"; --apagado
		end case; 
	end process; 
end Behavioral;