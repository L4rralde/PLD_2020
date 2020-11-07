library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_STD.ALL; 

--baudRate = clk*baudConf/2^21 => baudConf= 2^21*baudRate/(clk)
entity top is
    Port ( leds : out  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           Rx : in STD_LOGIC;
           reset : in STD_LOGIC; 
           AN : out STD_LOGIC_VECTOR(3 downto 0); 
           DISPLAY : out STD_LOGIC_VECTOR(7 downto 0); 
           PWM : out STD_LOGIC
           );
end top;
	
architecture Behavioral of top is
	component baudgen is
		Port ( CLK : in  STD_LOGIC;
           div : in  STD_LOGIC_VECTOR (7 downto 0);
           bauds : inout  STD_LOGIC);
	end component;

	component receiver is
    Port ( 
    	   clk : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           done : out  STD_LOGIC;
           data : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;

	component controlDisp is
	port(
		CLK : in STD_LOGIC; 
		byte_in : in STD_LOGIC_VECTOR(3 downto 0); 
		AN : out STD_LOGIC_VECTOR(3 downto 0) := "1111"; 
		DISPLAY : out STD_LOGIC_VECTOR(7 downto 0)
	); 
	end component;

	component servoControlable is
    Port ( 	 clk :  in  STD_LOGIC;--reloj de 50MHz
             selector :  inout  STD_LOGIC_VECTOR (2 downto 0);--selecciona las 4 posiciones
             PWM :  out  STD_LOGIC);--terminal donde sale la señal de PWM
	end component;

	signal prediv : STD_LOGIC_VECTOR(2 downto 0);
	signal fsampling : STD_LOGIC; 
	signal dataReg : STD_LOGIC_VECTOR(7 downto 0); 
	signal done : STD_LOGIC;
	signal byteData : STD_LOGIC_VECTOR (7 downto 0);

begin
	--Prediv freq = 50/8 MHz
	prescale : process(clk) is
	begin
		if(rising_edge(clk)) then 
			prediv <= prediv + 1;
		end if; 
	end process; 

	baudfrqgen : baudgen port map (prediv(2), x"00", fsampling);

	rec: receiver port map(fsampling, Rx, done, dataReg);
	

	write : process(clk, reset, dataReg, done) is 
	begin 
		if(rising_edge(CLK)) then 
			if(reset = '1') then 
				byteData <= "00000000";
			elsif(done = '1') then 
	 			byteData <= dataReg; 
			end if; 
		end if; 
	end process; 

	dispcontrol : controlDisp port map(clk, byteData(3 downto 0), AN, DISPLAY); 
	servo : servoControlable port map(clk, byteData(2 downto 0), PWM);
	leds <= byteData;


end Behavioral;