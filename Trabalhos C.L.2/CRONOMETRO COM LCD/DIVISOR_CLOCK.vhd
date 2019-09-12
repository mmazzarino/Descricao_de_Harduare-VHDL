----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:47:18 10/08/2018 
-- Design Name: 
-- Module Name:    DIVISOR_CLOCK - ARQ_DIVISOR_CLOCK 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DIVISOR_CLOCK is
    Port ( CLK_IN : in  STD_LOGIC;
           CONT_HIGH : in  INTEGER;
           CONT_TOTAL : in  INTEGER;
           CLK_OUT : out  STD_LOGIC
			  );
end DIVISOR_CLOCK;

architecture ARQ_DIVISOR_CLOCK of DIVISOR_CLOCK is
begin
process(CLK_IN)
variable CONT : INTEGER;
begin
	if(CLK_IN'event and CLK_IN = '1')then
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
end ARQ_DIVISOR_CLOCK;

