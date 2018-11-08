
--------------------------------------------------------------------------------
-- Course: Engenharia de Controle e Automação
-- Subject: Laboratório de Circuítos Lógicos II
-- Engineer: Matheus Mazzarino
-- Create Date: Novembro 2018 
-- Module Name: EDITOR_DE_TEXTOS - ARQ_EDITOR_DE_TEXTOS
-- Description: Editor de textos com teclado ps2 e display LCD 16x2 - Trabalho 8 Circuítos Lógicos 2 

------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDITOR_DE_TEXTOS is
	port(
			CLOCK_TECLADO : in STD_LOGIC;--a
			DADO_TECLADO : in STD_LOGIC;--b
			CLK_FPGA : in STD_LOGIC;--e
			DATA_DISPLAY : out STD_LOGIC_VECTOR(7 DOWNTO 0);--f
			EN_DISPLAY : out STD_LOGIC;--g
			RS_DISPLAY : out STD_LOGIC--h
		  );
end EDITOR_DE_TEXTOS;

------------------------------------------------------------------------------
architecture ARQ_EDITOR_DE_TEXTOS of EDITOR_DE_TEXTOS is

---------------------------declaração de sinais-------------------------------
	signal decoder_to_display: STD_LOGIC_VECTOR(7 DOWNTO 0);--d
	signal scancode_to_decoder: STD_LOGIC_VECTOR (7 downto 0);--c

---------------------------declaração de componentes--------------------------
component TECLADO_PS2 is
	Port(
			CLK_TEC : in STD_LOGIC;--a
			DADO_TEC: in STD_LOGIC;--b
			SCAN_CODE: out STD_LOGIC_VECTOR (7 downto 0)--c
			);
end component;

component DECODER_SCANCODE is
	Port(
			SCANCODE: in STD_LOGIC_VECTOR(7 downto 0);--c
			STANDARD_DISP: out STD_LOGIC_VECTOR (7 downto 0)--d
		   );
end component;

component DISPLAY_LCD_16X2 is
	Port(
			CLK1 : in STD_LOGIC;--e
	      OUT_DECODER: in STD_LOGIC_VECTOR(7 DOWNTO 0);--d
	   	DATA_LCD : out STD_LOGIC_VECTOR(7 DOWNTO 0);--f
			EN_OUT : out STD_LOGIC;--g
			RS_OUT : out STD_LOGIC--h
		   );
end component;

---------------------------conexão dos componentes----------------------------
begin
CONEXOES_TECLADO: TECLADO_PS2 port map(
													CLK_TEC => CLOCK_TECLADO,
													DADO_TEC => DADO_TECLADO,
													SCAN_CODE => scancode_to_decoder
          									   );
	
CONEXOES_DECODER: DECODER_SCANCODE port map(
														  SCANCODE => scancode_to_decoder,
														  STANDARD_DISP => decoder_to_display
														  );

CONEXOES_DISPLAY: DISPLAY_LCD_16X2 port map(
														  CLK1 => CLK_FPGA,
														  OUT_DECODER => decoder_to_display,
														  DATA_LCD => DATA_DISPLAY,
														  EN_OUT => EN_DISPLAY,
														  RS_OUT => RS_DISPLAY
														  );
														  

end ARQ_EDITOR_DE_TEXTOS;

