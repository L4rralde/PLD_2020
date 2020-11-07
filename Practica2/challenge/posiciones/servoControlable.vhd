--Código para controlar 4 posiciones para un servomotor Futaba
--implementado en la nexys2.
--Se considera una frec. de 100Hz (periodo de 10ms) del PWM.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY servoControlable is
    generic( Max: natural := 500000);
    Port ( 
        clk :  in  STD_LOGIC;--reloj de 50MHz
        selector :  inout  STD_LOGIC_VECTOR (2 downto 0);--selecciona las 4 posiciones
        PWM :  out  STD_LOGIC);--terminal donde sale la señal de PWM
end servoControlable;

ARCHITECTURE servoControlable of servoControlable is
   signal PWM_Count: integer range 1 to Max;--500000;
begin

generacion_PWM: process( clk, selector,PWM_Count)
    constant pos1: integer := 22632;  --representa a 1.00ms = 0°
    constant pos2: integer := 47402;  --representa a 1.25ms = 45°							
	constant pos3: integer := 72172;  --representa a 1.25ms = 45°
    constant pos4: integer := 96942;  --representa a 1.50ms = 90°
    constant pos5: integer := 121686; --representa a 2.00ms = 180°
    begin
        if rising_edge(clk)then PWM_Count <= PWM_Count + 1;
        end if;
        case (selector) is
             when "000" =>--con el selector en 00 se posiciona en servo en 0°
                 if PWM_Count <= pos1 then PWM <= '1';
                 else                                 
                    PWM <= '0';
                 end if;
                 when "001" =>-- con el selector en 01 se posiciona en servo en 45°
                     if PWM_Count <= pos2 then PWM <= '1';
                     else                                 
                          PWM <= '0';
                     end if;
                 when "010" =>-- con el selector en 11 se posiciona en servo en 90°
                     if PWM_Count <= pos3 then PWM <= '1';
                     else                                 
                        PWM <= '0';
                     end if;
                 when "011" =>-- con el selector en 10 se posiciona en servo en 180°
                     if PWM_Count <= pos4 then PWM <= '1';
                     else                                 
                        PWM <= '0';
                     end if;
                 when "100" =>-- con el selector en 10 se posiciona en servo en 180°
                     if PWM_Count <= pos5 then PWM <= '1';
                     else                                 
                        PWM <= '0';
                     end if;
                 when others => 
                        PWM <= '0';
             end case;
          end process generacion_PWM;

end servoControlable;

