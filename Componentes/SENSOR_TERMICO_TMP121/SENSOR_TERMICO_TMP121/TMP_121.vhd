----------------------------------------------------------------------------------
-- Company: 
-- Engineer: M.M.
-- Create Date:    17:12:05 10/16/2018 
-- Design Name: 
-- Module Name:    TMP_121 - ARQ_TMP_121 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
library UNISIM;
use UNISIM.VComponents.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity TMP_121 is

generic(
		TOTAL_1KHZ: INTEGER := 50_000;
		HIGH_1KHZ: INTEGER := 25_000;
		TOTAL_350MS: INTEGER := 17_500_000; 
		HIGH_350MS: INTEGER := 8_750_000;
		TOTAL_625HZ: INTEGER := 80_000;
		HIGH_625HZ: INTEGER := 40_000
		);
		
port(
		CLK: in STD_LOGIC; --50 mhz
		DO: in STD_LOGIC;
		CS1: out STD_LOGIC;
		CS_AD: out STD_LOGIC;
		BAR_DADOS_LCD: out  STD_LOGIC_VECTOR (7 downto 0);
		EN_LCD : out  STD_LOGIC;
	   RS_LCD : out  STD_LOGIC
	);		
end TMP_121;


architecture ARQ_TMP_121 of TMP_121 is


component DIVISOR_CLOCK
	Port (  
			  CLK_IN : in  STD_LOGIC; 
           CONT_HIGH : in  INTEGER;
           CONT_TOTAL : in  INTEGER;
           CLK_OUT : out  STD_LOGIC
			  );
end component;

component DISPLAY_LCD
	port ( 
			   CLK_IN : in  STD_LOGIC;
				CLK2 : in  STD_LOGIC;
				TEMPERATURA : in  INTEGER;
				DATA : out STD_LOGIC_VECTOR(7 downto 0);
				EN : out STD_LOGIC;
				RS : out STD_LOGIC
			);
end component;

signal clock_1khz, clock_625hz: STD_LOGIC;
signal recebe_dado: STD_LOGIC_VECTOR(7 downto 0);
signal temperatura: INTEGER := 0;
begin
CS_AD <= '1';
--conexões dos componentes

CLOCK1KHZ: DIVISOR_CLOCK port map(CLK_IN => CLK, CONT_HIGH => HIGH_1KHZ, CONT_TOTAL => TOTAL_1KHZ, CLK_OUT => clock_1khz);
--CLOCK350MS: DIVISOR_CLOCK port map(CLK_IN => CLK, CONT_HIGH => HIGH_350MS, CONT_TOTAL => TOTAL_350MS, CLK_OUT => clock_350ms);
CLOCK625hz: DIVISOR_CLOCK port map (CLK_IN => CLK, CONT_HIGH => HIGH_625HZ, CONT_TOTAL => TOTAL_625HZ, CLK_OUT => clock_625hz);
LCD: DISPLAY_LCD port map (CLK_IN => clock_1khz, CLK2 => clock_625hz, TEMPERATURA => temperatura, DATA => BAR_DADOS_LCD, EN => EN_LCD, RS => RS_LCD);



	process(clock_1khz)
	
	variable cont: INTEGER := 10;	
	begin
	
		if(clock_1khz'event and clock_1khz = '1')then
			
			case cont is		
				when 0 => CS1 <= '1';
							cont := cont + 1;
				
				--320 ms para atualização dos dados de temperatura
				
				
				when 320 => CS1 <= '0'; --inicio da leitura
							cont := cont + 1;
				
				when 321 => cont := cont + 1; --pula do bit D15
				
				when 322 => recebe_dado(7) <= DO; 
							cont := cont + 1;
				when 323 => recebe_dado(6) <= DO; 
							cont := cont + 1;
				when 324 => recebe_dado(5) <= DO; 
							cont := cont + 1;
				when 325 => recebe_dado(4) <= DO; 
							cont := cont + 1;
				when 326 => recebe_dado(3) <= DO; 
							cont := cont + 1;
				when 327 => recebe_dado(2) <= DO; 
							cont := cont + 1;
				when 328 => recebe_dado(1) <= DO; 
							cont := cont + 1;
				when 329 => recebe_dado(0) <= DO; 
							cont := cont + 1;
				when 350 => temperatura <= to_integer(unsigned(recebe_dado)); --temperatura recebe o dado
							cont := 0;                                           --convertido para integer
				when othe
				=> cont := cont + 1;
			end case;
		end if;
	end process;
end ARQ_TMP_121;