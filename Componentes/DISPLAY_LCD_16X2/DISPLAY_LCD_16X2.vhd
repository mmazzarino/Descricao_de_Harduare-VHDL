----------------------------------------------------------------------------------
-- Course: Engenharia de Controle e Automação
-- Subject: Laboratório de Circuítos Lógicos II
-- Engineer: Matheus Mazzarino
-- Create Date: Outubro 2018 
-- Module Name: COMPONENTE DISPLAY LCD 16 X 2

-- Description: 

----------------------------------------------------------------------------------
library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use UNISIM.VComponents.all;

entity DISPLAY_LCD_16X2 is
	port(
			CLK : in STD_LOGIC;
			DATA : out STD_LOGIC_VECTOR(7 DOWNTO 0);
			EN : out STD_LOGIC;
			RS : out STD_LOGIC
		 );			
end DISPLAY_LCD_16X2;

architecture ARQ_DISPLAY_LCD_16X2 of DISPLAY_LCD_16X2 is


---------------------------------DECLARAÇÃO DE COMPONENTES------------------------
component DIVISOR_DE_CLOCK is
	Port ( 
			  CLK_IN : in  STD_LOGIC;
           CONT_HIGH : in  INTEGER;
           CONT_TOTAL : in  INTEGER;
			  ACIONAMENTO : in BOOLEAN;
           CLK_OUT : out  STD_LOGIC
			 );
end component;


---------------------------------DEFINIÇÃO DE TIPOS-------------------------------
type ESTADOS_CONF_INICIAL is (FAZER, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, FEITO);


---------------------------------DECLARAÇÃO DE SINAIS-----------------------------
signal ea_ci : ESTADOS_CONF_INICIAL := FAZER;-- ea_ci = estado atual da configuração inicial
signal clk_configu: STD_LOGIC;


---------------------------------INÍCIO-------------------------------------------
begin


---------------------------------INSTANCIAÇÃO DE COMPONENTE-----------------------
	CLKK: DIVISOR_DE_CLOCK port map(
												CLK_IN => CLK, 
												CONT_HIGH => 30_000, 
												CONT_TOTAL => 60_000, 
												ACIONAMENTO => TRUE, 
												CLK_OUT => clk_configu
											 );
	
	
---------------------------------PROCESSO PARA CONFIGURAÇÃO INICIAL---------------
	CONFIGURACAO_INICIAL: process(clk_configu)
	variable conta_2 : INTEGER := 1;
	begin
		if(clk_configu'event and clk_configu = '1')then
			case ea_ci is
				when FAZER => ea_ci <= A;
				when A => RS <= '0'; ea_ci <= B; 
				when B => EN <= '1'; ea_ci <= C;
				when C => DATA <= (x"38"); ea_ci <= D;
				when D => EN <= '0'; ea_ci <= E;
				when E => EN <= '1'; ea_ci <= F;
				when F => DATA <= (x"0F"); ea_ci <= G;
				when G => EN <= '0'; ea_ci <= H;
				when H => EN <= '1'; ea_ci <= I;
				when I => DATA <= (x"06"); ea_ci <= J;
				when J => EN <= '0'; ea_ci <= K;
				when K => EN <= '1'; ea_ci <= L;
				when L => DATA <= (x"01"); ea_ci <= M;
				when M => EN <= '0'; ea_ci <= N;
				when N => EN <= '1'; ea_ci <= O;
				when O => RS <= '1'; ea_ci <= FEITO;
				when others => NULL; 	
			end case;		
		end if;
	end process;			
end ARQ_DISPLAY_LCD_16X2;

