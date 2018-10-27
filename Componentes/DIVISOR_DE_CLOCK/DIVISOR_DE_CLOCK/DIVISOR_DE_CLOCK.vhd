----------------------------------------------------------------------------------
-- Course: Engenharia de Controle e Automação
-- Subject: Laboratório de Circuítos Lógicos II
-- Engineer: Matheus Mazzarino
-- Create Date: Outubro 2018 
-- Module Name: DIVISOR_DE_CLOCK - ARQ_DIVISOR_DE_CLOCK 

-- Description: Recebe um clock, o número de eventos de clock para ficar em nível lógico 
				--	 alto, o número de eventos de clock para ficar em nível lógico baixo e re-
				--  torna o clock resultante.

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DIVISOR_DE_CLOCK is
    Port ( 
			  CLK_IN : in  STD_LOGIC;
           CONT_HIGH : in  INTEGER;
           CONT_TOTAL : in  INTEGER;
			  ACIONAMENTO : in BOOLEAN;
           CLK_OUT : out  STD_LOGIC
			 );
end DIVISOR_DE_CLOCK;

architecture ARQ_DIVISOR_DE_CLOCK of DIVISOR_DE_CLOCK is
signal recebe_clock: STD_LOGIC;

begin
	
with ACIONAMENTO select 
	recebe_clock <= CLK_IN when TRUE,
					       '0' when others;
							
process(recebe_clock)
variable CONT : INTEGER;
begin
	if(recebe_clock'event and recebe_clock = '1')then
		if(CONT < CONT_HIGH)then
			CLK_OUT <= '1';
			CONT := CONT + 1;
		elsif(CONT < CONT_TOTAL)then
			CLK_OUT <= '0';
			CONT := CONT + 1;
		else
			CONT := 0;
		end if;
	end if;
end process;
end ARQ_DIVISOR_DE_CLOCK;



