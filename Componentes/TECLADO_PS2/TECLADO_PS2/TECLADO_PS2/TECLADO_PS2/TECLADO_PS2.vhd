
--------------------------------------------------------------------------------
-- Course: Engenharia de Controle e Automação
-- Subject: Laboratório de Circuítos Lógicos II
-- Engineer: Matheus Mazzarino
-- Create Date: Outubro 2018 
-- Module Name: COMPONENTE TECLADO PS2
--
-- Description: 

------------------------------------------------------------------------------
library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use UNISIM.VComponents.all;
 

entity TECLADO_PS2 is
	port(
			CLK_TEC : in STD_LOGIC;
			DADO_TEC: in STD_LOGIC;
			SEGM7: out STD_LOGIC_VECTOR (6 downto 0)
			);
end TECLADO_PS2;

architecture ARQ_TECLADO_PS2 of TECLADO_PS2 is
signal scanCode: STD_LOGIC_VECTOR(7 downto 0);
signal SCAN_CODE: STD_LOGIC_VECTOR(7 downto 0);
begin

	LEITOR_SC: process(CLK_TEC)
	variable conta_pulso: INTEGER := 0;
	begin
		if(CLK_TEC'event and CLK_TEC = '0')then
			case conta_pulso is
				when 0 => conta_pulso := conta_pulso + 1;
				when 1 to 8 => scanCode(conta_pulso - 1) <= DADO_TEC;
									conta_pulso := conta_pulso + 1;
				when 9 => SCAN_CODE <= scanCode;
							conta_pulso := conta_pulso + 1;
				when 10 => if(DADO_TEC = '1')then
									conta_pulso := conta_pulso + 1;
							else
									null;
								end if;
				when 11 => if(DADO_TEC = '0')then
									conta_pulso := conta_pulso + 1;
								else
									null;
								end if;
				when 12 to 20 => conta_pulso := conta_pulso + 1;
				when 21 => if(DADO_TEC = '1')then
									conta_pulso := conta_pulso + 1;
							else
									null;
							end if;
				when 22 => if(DADO_TEC = '0')then
									conta_pulso := conta_pulso + 1;
							else
									null;
								end if;
				when 23 to 31 => conta_pulso := conta_pulso + 1;
				when 32 => if(DADO_TEC = '1')then
									conta_pulso := 0;
							  else
									null;
							  end if;
				when others => null;
			end case;
			
			case SCAN_CODE is
				when (x"16") => SEGM7 <= "1001111";
				when (x"1e") => SEGM7 <= "0010010";
				when others => null;
			end case;
				
		end if;
	end process;																	
end ARQ_TECLADO_PS2;

