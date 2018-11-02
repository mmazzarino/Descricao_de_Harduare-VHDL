--------------------------------------------------------------------------------
-- Course: Engenharia de Controle e Automação
-- Subject: Laboratório de Circuítos Lógicos II
-- Engineer: Matheus Mazzarino
-- Create Date: Outubro 2018 
-- Module Name: COMPONENTE DISPLAY LCD 16 X 2
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

entity DISPLAY_LCD_16X2 is
	port(
			CLK1 : in STD_LOGIC;
			OUT_DECODER: in STD_LOGIC_VECTOR(7 DOWNTO 0);
			IN_LCD_OUT : out STD_LOGIC_VECTOR(7 DOWNTO 0);
			EN_OUT : out STD_LOGIC;
			RS_OUT : out STD_LOGIC
		 );			
end DISPLAY_LCD_16X2;

architecture ARQ_DISPLAY_LCD_16X2 of DISPLAY_LCD_16X2 is


-----------------------------DECLARAÇÃO DE COMPONENTES------------------------
component DIVISOR_DE_CLOCK is
	Port ( 
			  CLK_IN : in  STD_LOGIC; --50MHZ
           CONT_HIGH : in  INTEGER;
           CONT_TOTAL : in  INTEGER;
			  ACIONAMENTO : in BOOLEAN;
           CLK_OUT : out  STD_LOGIC
			 );
end component;


-----------------------------DEFINIÇÃO DE TIPOS-------------------------------
type ESTADOS_CONF_INICIAL is (NAO_CONFIGURADO, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, CONFIGURADO);
type ARRANJO_TEXTO is ARRAY (NATURAL RANGE <>) of STD_LOGIC_VECTOR(7 DOWNTO 0);
type ARRANJO_ENDERECOS is ARRAY (NATURAL RANGE <>) of STD_LOGIC_VECTOR(7 DOWNTO 0);


-----------------------------DECLARAÇÃO DE SINAIS-----------------------------
signal ea_ci : ESTADOS_CONF_INICIAL := NAO_CONFIGURADO;-- ea_ci = estado atual da configuração inicial
signal clk_configu: STD_LOGIC;
signal clk_escrita: STD_LOGIC;
signal dados_entrada: ARRANJO_TEXTO(0 TO 15) := ((x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"),(x"39"));
signal enderecos: ARRANJO_TEXTO(0 TO 31) := ((x"84"),(x"85"),(x"86"),(x"87"),(x"88"),(x"89"),(x"8A"),(x"8B"),(x"8C"),(x"8D"),(x"8E"),(x"8F"),(x"90"),(x"91"),(x"92"),(x"93"),
															(x"C0"),(x"C1"),(x"C2"),(x"C3"),(x"C4"),(x"C5"),(x"C6"),(x"C7"),(x"C8"),(x"C9"),(x"CA"),(x"CB"),(x"CC"),(x"CD"),(x"CE"),(x"CF"));

signal EN_CONF : STD_LOGIC := 'Z';
signal EN_OB : STD_LOGIC := 'Z';
signal EN_ESCR : STD_LOGIC := 'Z';
signal RS_CONF : STD_LOGIC := 'Z';
signal RS_OB : STD_LOGIC := 'Z';
signal RS_ESCR : STD_LOGIC := 'Z';
signal IN_LCD_CONF : STD_LOGIC_VECTOR (7 downto 0) := "ZZZZZZZZ";
signal IN_LCD_OB : STD_LOGIC_VECTOR (7 downto 0) := "ZZZZZZZZ";
signal IN_LCD_ESCR : STD_LOGIC_VECTOR (7 downto 0) := "ZZZZZZZZ";

CONSTANT ENT : STD_LOGIC_VECTOR (7 downto 0) := "11111110";
CONSTANT TAB : STD_LOGIC_VECTOR (7 downto 0) := "10110111";
CONSTANT ESC : STD_LOGIC_VECTOR (7 downto 0) := "11110111";
CONSTANT BSP : STD_LOGIC_VECTOR (7 downto 0) := "11101111";

-----------------------------INÍCIO-------------------------------------------
begin


-----------------------------INSTANCIAÇÃO DE COMPONENTE-----------------------
	CLK_A: DIVISOR_DE_CLOCK port map(
												CLK_IN => CLK1, 
												CONT_HIGH => 40_000, 
												CONT_TOTAL => 80_000, 
												ACIONAMENTO => TRUE, 
												CLK_OUT => clk_configu
											 );
	
	CLK_B: DIVISOR_DE_CLOCK port map(
												CLK_IN => CLK1, 
												CONT_HIGH => 5, 
												CONT_TOTAL => 10, 
												ACIONAMENTO => TRUE, 
												CLK_OUT => clk_escrita
											 );
	
-----------------------------PROCESSO PARA MULTIPLEXAÇÃO DE SINAIS------------
	
	MULTIPLEX : process(clk_escrita)
	begin
	if(clk_escrita'event and clk_escrita = '1')then
		if(ea_ci = NAO_CONFIGURADO)then		
			EN_OUT <= EN_CONF;
			RS_OUT <= RS_CONF;
			IN_LCD_OUT <= IN_LCD_CONF;
		elsif(ea_ci = CONFIGURADO)then		
			if(OUT_DECODER = ENT or OUT_DECODER = ESC or OUT_DECODER = TAB or OUT_DECODER = BSP)then
				EN_OUT <= EN_OB;
				RS_OUT <= RS_OB;
				IN_LCD_OUT <= IN_LCD_OB;
			else
				EN_OUT <= EN_ESCR;
				RS_OUT <= RS_ESCR;
				IN_LCD_OUT <= IN_LCD_ESCR;
			end if;
		end if;
		end if;
	end process;
						
-----------------------------PROCESSO PARA CONFIGURAÇÃO INICIAL---------------	
	
	CONFIGURACAO_INICIAL: process(clk_configu)
	variable conta1: INTEGER RANGE 0 to 31 := 0;
	variable conta2: INTEGER RANGE 0 to 2 := 0;
	begin
		if(clk_configu'event and clk_configu = '1')then
			case ea_ci is
				when NAO_CONFIGURADO => ea_ci <= A;
				when A => RS_CONF <= '0'; ea_ci <= B; 
				when B => EN_CONF <= '1'; ea_ci <= C;
				when C => IN_LCD_CONF <= (x"38"); ea_ci <= D;
				when D => EN_CONF <= '0'; ea_ci <= E;
				when E => EN_CONF <= '1'; ea_ci <= F;
				when F => IN_LCD_CONF <= (x"0F"); ea_ci <= G;
				when G => EN_CONF <= '0'; ea_ci <= H;
				when H => EN_CONF <= '1'; ea_ci <= I;
				when I => IN_LCD_CONF <= (x"06"); ea_ci <= J;
				when J => EN_CONF <= '0'; ea_ci <= K;
				when K => EN_CONF <= '1'; ea_ci <= L;
				when L => IN_LCD_CONF <= (x"01"); ea_ci <= M;
				when M => EN_CONF <= '0'; ea_ci <= N;
				when N => EN_CONF <= '1'; ea_ci <= O;
				when O => RS_CONF <= '1'; ea_ci <= CONFIGURADO;
				when others => NULL; 	
			end case;		
		end if;
	end process;

-------------------------------PROCESSO PARA FUNÇÕES BASICAS DO TECLADO---------
	
	OPERACOES_BASICAS : process(OUT_DECODER, clk_configu)
	variable conta1: INTEGER RANGE 0 to 31 := 0;
	variable conta2: INTEGER RANGE 0 to 2 := 0;
	variable conta_end: INTEGER RANGE 0 to 31 := 0;
	variable byte_teclado: STD_LOGIC_VECTOR (7 downto 0) := "ZZZZZZZZ";
	
	begin
		byte_teclado := OUT_DECODER;
		
		if(clk_configu'event and clk_configu = '1')then
			if(ea_ci = CONFIGURADO)then
				case byte_teclado is										
					when ENT => EN_OB <= '1';--ENTER
									RS_OB <= '0';
									IN_LCD_OB <= enderecos<16>;
									EN_OB <= '0';
									RS_OB <= '1';
									conta1 := 16;
									conta_end := 16;
									byte_teclado := "ZZZZZZZZ";
					
					when TAB => EN_OB <= '1';
									RS_OB <= '0';
									IN_LCD_OB <= enderecos<(conta1 + 3)>;
									EN_OB <= '0';
									RS_OB <= '1';
									conta1 := conta1 + 3;
									conta_end := conta_end + 3;
									byte_teclado := "ZZZZZZZZ";
									
					when ESC => EN_OB <= '1';
									RS_OB <= '0';
									IN_LCD_OB <= (x"00");
									EN_OB <= '0';
									RS_OB <= '1';
									conta1 := 0;
									conta_end := 0;
									byte_teclado := "ZZZZZZZZ";
									
					when BSP => EN_OB <= '1';--BACKSPACE
											RS_OB <= '0';
											IN_LCD_OB <= enderecos<(conta_end - 1)>;
											EN_OB <= '0';
											RS_OB <= '1';
											dados_entrada(conta1 - 1) <= (x"20");
											conta_end := conta_end - 1;
											conta1 := conta1 - 1;
											byte_teclado := "ZZZZZZZZ";
					when others => null;
				end case;	
			end if;
		end if;	
	end process;
	
---------------------------------PROCESSO ESCRITA DOS DADOS DO TECLADO------------	
	
	ESCRITA : process(clk_escrita)
	variable conta1 : INTEGER RANGE 0 to 31;
	variable conta2 : INTEGER RANGE 0 to 2;
	begin
		if(clk_escrita'event and clk_escrita = '1')then
			case conta2 is
				when 0 => EN_ESCR <= '1'; conta2 := conta2 + 1;
				when 1 => IN_LCD_ESCR <= dados_entrada<conta1>; conta2 := conta2 + 1;
				when 2 => EN_ESCR <= '0'; conta2 := 0;
								if(conta1 < 31)then 
									conta1 := conta1 + 1;
						      else
									conta1 := 0;
								end if;
				when others => null;
			end case;
		end if;
	end process;				
end ARQ_DISPLAY_LCD_16X2;
