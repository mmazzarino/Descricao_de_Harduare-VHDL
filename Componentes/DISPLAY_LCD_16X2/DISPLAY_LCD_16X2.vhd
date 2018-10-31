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
			CLK1 : in STD_LOGIC;
			OUT_PS2: in STD_LOGIC_VECTOR(7 DOWNTO 0);
			IN_LCD : out STD_LOGIC_VECTOR(7 DOWNTO 0);
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
type ARRANJO_TEXTO is ARRAY (NATURAL RANGE <>) of STD_LOGIC_VECTOR(7 DOWNTO 0);
type ARRANJO_ENDERECOS is ARRAY (NATURAL RANGE <>) of STD_LOGIC_VECTOR(7 DOWNTO 0);

---------------------------------DECLARAÇÃO DE SINAIS-----------------------------
signal ea_ci : ESTADOS_CONF_INICIAL := FAZER;-- ea_ci = estado atual da configuração inicial
signal clk_configu: STD_LOGIC;
signal dados_entrada: ARRANJO_TEXTO(0 TO 31);-- := ((x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"));
signal enderecos: ARRANJO_TEXTO(0 TO 31) := ((x"84"),(x"85"),(x"86"),(x"87"),(x"88"),(x"89"),(x"8A"),(x"8B"),(x"8C"),(x"8D"),(x"8E"),(x"8F"),(x"90"),(x"91"),(x"92"),(x"93"),
															(x"C0"),(x"C1"),(x"C2"),(x"C3"),(x"C4"),(x"C5"),(x"C6"),(x"C7"),(x"C8"),(x"C9"),(x"CA"),(x"CB"),(x"CC"),(x"CD"),(x"CE"),(x"CF")
--signal contador_enderecos : INTEGER;
--signal contador_caracteres : INTEGER;
---------------------------------INÍCIO-------------------------------------------
begin


---------------------------------INSTANCIAÇÃO DE COMPONENTE-----------------------
	CLKK: DIVISOR_DE_CLOCK port map(
												CLK_IN => CLK1, 
												CONT_HIGH => 30_000, 
												CONT_TOTAL => 60_000, 
												ACIONAMENTO => TRUE, 
												CLK_OUT => clk_configu
											 );
	
	
---------------------------------PROCESSO PARA CONFIGURAÇÃO INICIAL---------------
	CONFIGURACAO_INICIAL: process(clk_configu)
	variable conta_2 : INTEGER := 1;
	variable conta1: INTEGER RANGE 0 to 31 := 0;
	variable conta2: INTEGER RANGE 0 to 2 := 0;
	begin
		if(clk_configu'event and clk_configu = '1')then
			case ea_ci is
				when FAZER => ea_ci <= A;
				when A => RS <= '0'; ea_ci <= B; 
				when B => EN <= '1'; ea_ci <= C;
				when C => IN_LCD <= (x"38"); ea_ci <= D;
				when D => EN <= '0'; ea_ci <= E;
				when E => EN <= '1'; ea_ci <= F;
				when F => IN_LCD <= (x"0F"); ea_ci <= G;
				when G => EN <= '0'; ea_ci <= H;
				when H => EN <= '1'; ea_ci <= I;
				when I => IN_LCD <= (x"06"); ea_ci <= J;
				when J => EN <= '0'; ea_ci <= K;
				when K => EN <= '1'; ea_ci <= L;
				when L => IN_LCD <= (x"01"); ea_ci <= M;
				when M => EN <= '0'; ea_ci <= N;
				when N => EN <= '1'; ea_ci <= O;
				when O => RS <= '1'; ea_ci <= FEITO;
				when others => NULL; 	
			end case;		
		end if;
	end process;
	
	OPERACOES_BASICAS : process(OUT_PS2, clk_configu)
	variable conta1: INTEGER RANGE 0 to 31 := 0;
	variable conta_out_char_lcd: INTEGER RANGE 0 to 31 := 0;
	variable conta_out_ender_lcd: INTEGER RANGE 0 to 31 := 0;
	variable conta2: INTEGER RANGE 0 to 2 := 0;
	variable conta_end: INTEGER RANGE 0 to 31 := 0;
	variable byte_teclado: STD_LOGIC_VECTOR (7 downto 0) := ("ZZZZZZZZ");
	begin
		byte_teclado := OUT_PS2;
--		contador_enderecos <= conta_end;
--		contador_caracteres <= conta1;
		if(clk_configu'event and clk_configu = '1')then
			if(ea_ci = FEITO)then
				case byte_teclado is										
					when ENT => EN <= '1';--ENTER
									RS <= '0';
									IN_LCD <= enderecos(16);
									EN <= '0';
									RS <= '1';
									conta1 := 16;
									conta_end := 16;
									byte_teclado := ("ZZZZZZZZ");
					
					when TAB => EN <= '1';
									RS <= '0';
									IN_LCD <= enderecos(conta1 + 3);
									EN <= '0';
									RS <= '1';
									conta1 := conta1 + 3;
									conta_end := cont_end + 3;
									byte_teclado := ("ZZZZZZZZ");
									
					when ESC => EN <= '1';
									RS <= '0';
									IN_LCD <= (x"00");
									EN <= '0';
									RS <= '1';
									conta1 := 0;
									conta_end := 0;
									byte_teclado := ("ZZZZZZZZ");
									
					when BSP => EN <= '1';--BACKSPACE
											RS <= '0';
											IN_LCD <= enderecos(conta_end - 1);
											EN <= '0';
											RS <= '1';
											entrada_dados(conta1 - 1) <= (x"20");
											conta_end := conta_end - 1;
											conta1 := conta1 - 1;
											byte_teclado := ("ZZZZZZZZ");
				
					when "ZZZZZZ" => case conta2 is
												when 0 => EN <= '1'; conta2 := conta2 + 1;
												when 1 => IN_LCD <= dados_entrada(conta_out_char_lcd); conta2 := conta2 + 1;
												when 2 => EN <= '0'; conta_out_char_lcd := conta_out_char_lcd + 1; conta2 := 0;
											end case;
											if(conta_out_char_lcd = 32)then 
												conta2 := 0; 
											end if;
					
					when others => if(conta1 < 31)then
											dados_entrada(conta1) <= byte_teclado; 
											conta1 := conta1 + 1; 
											conta_end <= conta_end + 1;
											byte_teclado := ("ZZZZZZZZ");
										else
											dados_entrada(conta1) <= byte_teclado; conta1 := 0; conta_end <= 0;
											byte_teclado := ("ZZZZZZZZ");
										end if;
				end case;	
			end if;
		end if;	
	end process;
	
--	ESCRITA : process(clk_configu, contador_enderecos, contador_caracteres)
--	begin
		
						
end ARQ_DISPLAY_LCD_16X2;
