library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity top is
    Port ( clk : in  STD_LOGIC;
           res : in  STD_LOGIC;
           hab : in  STD_LOGIC;
           dir : in  STD_LOGIC;
           OnDisp : out  STD_LOGIC_VECTOR(3 downto 0);
           disp : out  STD_LOGIC_VECTOR (6 downto 0));
end top;

architecture Behavioral of top is
	component counter4_b is
	    Port ( clk : in  STD_LOGIC;
	           hab : in  STD_LOGIC;
	           dir : in  STD_LOGIC;
	           res : in  STD_LOGIC;
	           cnt : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;

	component codificador_7s is
	    Port ( cont : in  STD_LOGIC_VECTOR (3 downto 0);
	           disp : out  STD_LOGIC_VECTOR (6 downto 0));
	end component;

	component seconds is
    	Port ( 	clk : in  STD_LOGIC;
           		oneSecond : out  STD_LOGIC);
	end component;
	signal count : STD_LOGIC_VECTOR(3 downto 0); 
	signal sec1: STD_LOGIC; 

	
begin

	U1_second : seconds port map (clk, sec1); 
	U2_count : counter4_b port map (sec1, hab, dir, res, count);
	U3_decod : codificador_7s port map (count, disp);
	OnDisp <= "0111"; 
end Behavioral;

