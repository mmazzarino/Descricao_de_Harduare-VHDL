--------------------------------------------------------------------------------
-- Course: Engenharia de Controle e Automação
-- Subject: Laboratório de Circuítos Lógicos II
-- Engineer: Matheus Mazzarino
-- Create Date: Novembro 2018 
-- Module Name: DECODER_SCANCODE
-- Description: COMPONENTE QUE DECODIFICA O SCANCODE DO TECLADO PS2 PARA O DISPLAY LCD 16x2

------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECODER_SCANCODE is
	port(
			SCANCODE: in STD_LOGIC_VECTOR(7 downto 0);
			STANDARD_DISP: out STD_LOGIC_VECTOR (7 downto 0)
		 );	
end DECODER_SCANCODE;

architecture ARQ_DECODER_SCANCODE of DECODER_SCANCODE is
begin
	DECODIFICA: process(SCANCODE)
	begin
		case SCANCODE is
			when x"1c" => STANDARD_DISP <= x"41";--A
			when x"32" => STANDARD_DISP <= x"42";--B
			when x"21" => STANDARD_DISP <= x"43";--C
			when x"23" => STANDARD_DISP <= x"44";--D
			when x"24" => STANDARD_DISP <= x"45";--E
			when x"2b" => STANDARD_DISP <= x"46";--F
			when x"34" => STANDARD_DISP <= x"47";--G
			when x"33" => STANDARD_DISP <= x"48";--H
			when x"43" => STANDARD_DISP <= x"49";--I
			when x"3b" => STANDARD_DISP <= x"4a";--J
			when x"42" => STANDARD_DISP <= x"4b";--K
			when x"4b" => STANDARD_DISP <= x"4c";--L
			when x"3a" => STANDARD_DISP <= x"4d";--M
			when x"31" => STANDARD_DISP <= x"4e";--N
			when x"44" => STANDARD_DISP <= x"4f";--O
			when x"4d" => STANDARD_DISP <= x"50";--P
			when x"15" => STANDARD_DISP <= x"51";--Q
			when x"2d" => STANDARD_DISP <= x"52";--R
			when x"1b" => STANDARD_DISP <= x"53";--S
			when x"2c" => STANDARD_DISP <= x"54";--T
			when x"3c" => STANDARD_DISP <= x"55";--U
			when x"2a" => STANDARD_DISP <= x"56";--V
			when x"1d" => STANDARD_DISP <= x"57";--W
			when x"22" => STANDARD_DISP <= x"58";--X
			when x"35" => STANDARD_DISP <= x"59";--Y
			when x"1a" => STANDARD_DISP <= x"5a";--Z
			when (x"69" or x"16") => STANDARD_DISP <= x"31";--1
			when (x"72" or x"1e") => STANDARD_DISP <= x"32";--2
			when (x"7a" or x"26") => STANDARD_DISP <= x"33";--3
			when (x"6b" or x"25") => STANDARD_DISP <= x"34";--4
			when (x"73" or x"2e") => STANDARD_DISP <= x"35";--5
			when (x"74" or x"36") => STANDARD_DISP <= x"36";--6
			when (x"6c" or x"3d") => STANDARD_DISP <= x"37";--7
			when (x"75" or x"3e") => STANDARD_DISP <= x"38";--8
			when (x"7d" or x"46") => STANDARD_DISP <= x"39";--9
			when (x"70" or x"45") => STANDARD_DISP <= x"30";--0			
			when (x"5a" or x"e0") => STANDARD_DISP <= x"c0";--ENTER
			when x"0d" => STANDARD_DISP <= x"80";--TAB
			when x"76" => STANDARD_DISP <= x"81";--ESC
			when x"66" => STANDARD_DISP <= x"82";--BACKSPACE
			when x"29" => STANDARD_DISP <= x"fe";--SPACE			
		end case;
	end process;
end ARQ_DECODER_SCANCODE;

