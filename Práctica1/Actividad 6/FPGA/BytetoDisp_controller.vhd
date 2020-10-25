library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity BytetoDisp_controller is
port(
	CLK : in STD_LOGIC; 
	byte_in : in STD_LOGIC_VECTOR(7 downto 0); 

	AN : out STD_LOGIC_VECTOR(3 downto 0) := "1111"; 
	DISPLAY : out STD_LOGIC_VECTOR(7 downto 0)
); 
end BytetoDisp_controller;

architecture Behavioral of BytetoDisp_controller is
	signal P : STD_LOGIC_VECTOR(9 downto 0); 
	signal UNI, DEC, CEN : STD_LOGIC_VECTOR(3 downto 0); 
	signal SEL : STD_LOGIC_VECTOR(1 downto 0); 
	signal D : STD_LOGIC_VECTOR(3 downto 0);
	signal contadors : integer range 1 to 6250 := 1; 
	signal SAL_250us : STD_LOGIC;  
begin

	bin2BCD : process(byte_in)
		VARIABLE C_D_U:STD_LOGIC_VECTOR(17 DOWNTO 0);
	begin 
		--ciclo de inicialización
		FOR I IN 0 TO 17 LOOP --
			C_D_U(I) := '0'; -- se inicializa con 0
		END LOOP;
		C_D_U(7 DOWNTO 0) := byte_in; --tempo de 8 bits
		--ciclo de asignación C-D-U
		FOR I IN 0 TO 7 LOOP
			-- los siguientes condicionantes comparan (>=5) y suman 3
			IF C_D_U(11 DOWNTO 8) > 4 THEN -- U
				C_D_U(11 DOWNTO 8):= C_D_U(11 DOWNTO 8)+3;
			END IF;
			IF C_D_U(15 DOWNTO 12) > 4 THEN -- D
				C_D_U(15 DOWNTO 12):= C_D_U(15 DOWNTO 12)+3;
			END IF;
			IF C_D_U(17 DOWNTO 16) > 4 THEN -- C
				C_D_U(17 DOWNTO 16):= C_D_U(17 DOWNTO 16)+3;
			END IF;
			-- realiza el corrimiento
			C_D_U(17 DOWNTO 1):= C_D_U(16 DOWNTO 0);
		END LOOP;
		P<=C_D_U(17 DOWNTO 8); -- guarda en P y en seguida se separan UM-C-D-U
	end process; 

	UNI <= P(3 downto 0); 
	DEC <= P(7 downto 4); 
	CEN <= "00"&P(9 downto 8); 

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

	disp_sel : process(SAL_250us, SEL, UNI, DEC, CEN)
	begin 
		if(rising_edge(SAL_250us)) then 
			SEL <= SEL+1; 
			case(SEL) is 
				when "00" => AN <="0111"; D <= UNI; -- UNIDADES
				when "01" => AN <="1011"; D <= DEC; -- DECENAS
				when "10" => AN <="1101"; D <= CEN; -- CENTENAS
				when OTHERS=>AN <="1111"; -- OFF
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
			when "0101" => DISPLAY <= "01001001"; --5
			when "0110" => DISPLAY <= "01000001"; --6
			when "0111" => DISPLAY <= "00011111"; --7
			when "1000" => DISPLAY <= "00000001"; --8
			when "1001" => DISPLAY <= "00001001"; --9
			when OTHERS => DISPLAY <= "11111111"; --apagado
		end case; 
	end process; 
end Behavioral;

