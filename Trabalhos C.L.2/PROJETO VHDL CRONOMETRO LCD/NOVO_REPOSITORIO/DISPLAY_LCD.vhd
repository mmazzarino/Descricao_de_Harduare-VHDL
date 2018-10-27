----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:21:49 10/09/2018 
-- Design Name: 
-- Module Name:    DISPLAY_LCD - ARQ_DISPLAY_LCD 
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
	library UNISIM;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.STD_LOGIC_UNSIGNED.ALL;
	use IEEE.NUMERIC_STD.ALL;
	use IEEE.STD_LOGIC_ARITH.ALL; 
	use UNISIM.VComponents.all;


entity DISPLAY_LCD is 
	generic(
			  conf_1 : STD_LOGIC_VECTOR(7 downto 0) := (x"38");
   		  conf_2 : STD_LOGIC_VECTOR(7 downto 0) := (x"0F");
			  conf_3 : STD_LOGIC_VECTOR(7 downto 0) := (x"06");
	        conf_4 : STD_LOGIC_VECTOR(7 downto 0) := (x"01");
					N0 : STD_LOGIC_VECTOR(7 downto 0) := (x"30");
					N1 : STD_LOGIC_VECTOR(7 downto 0) := (x"31");
					N2 : STD_LOGIC_VECTOR(7 downto 0) := (x"32");
					N3 : STD_LOGIC_VECTOR(7 downto 0) := (x"33");
					N4 : STD_LOGIC_VECTOR(7 downto 0) := (x"34");
					N5 : STD_LOGIC_VECTOR(7 downto 0) := (x"35");
					N6 : STD_LOGIC_VECTOR(7 downto 0) := (x"36");
					N7 : STD_LOGIC_VECTOR(7 downto 0) := (x"37");
					N8 : STD_LOGIC_VECTOR(7 downto 0) := (x"38");
					N9 : STD_LOGIC_VECTOR(7 downto 0) := (x"39");
					LA : STD_LOGIC_VECTOR(7 downto 0) := (x"41");
					LE : STD_LOGIC_VECTOR(7 downto 0) := (x"45");
					LI : STD_LOGIC_VECTOR(7 downto 0) := (x"49");
					LO : STD_LOGIC_VECTOR(7 downto 0) := (x"4f");
					LC : STD_LOGIC_VECTOR(7 downto 0) := (x"43");
				  L_D : STD_LOGIC_VECTOR(7 downto 0) := (x"44");
					LF : STD_LOGIC_VECTOR(7 downto 0) := (x"46");
					LG : STD_LOGIC_VECTOR(7 downto 0) := (x"47");
					LL : STD_LOGIC_VECTOR(7 downto 0) := (x"4c");
					LM : STD_LOGIC_VECTOR(7 downto 0) := (x"4d");
					LN : STD_LOGIC_VECTOR(7 downto 0) := (x"4e");
					LP : STD_LOGIC_VECTOR(7 downto 0) := (x"50");
					LR : STD_LOGIC_VECTOR(7 downto 0) := (x"52");
					LS : STD_LOGIC_VECTOR(7 downto 0) := (x"53");
					LT : STD_LOGIC_VECTOR(7 downto 0) := (x"54");
					LU : STD_LOGIC_VECTOR(7 downto 0) := (x"55");
					LV : STD_LOGIC_VECTOR(7 downto 0) := (x"56");
					LW : STD_LOGIC_VECTOR(7 downto 0) := (x"57");
		         DP : STD_LOGIC_VECTOR(7 downto 0) := (x"3a");
			      ESP: STD_LOGIC_VECTOR(7 downto 0) := (x"20");
				  POS1: STD_LOGIC_VECTOR(7 downto 0) := (x"84");
				  POS2: STD_LOGIC_VECTOR(7 downto 0) := (x"c0")
				);
				
				
   port ( 
			  CLK_IN : in  STD_LOGIC;	 
           SEGUNDO_UNIT : in  INTEGER;
           SEGUNDO_DEZE : in  INTEGER;
           MINUTO_UNIT : in  INTEGER;
           MINUTO_DEZE : in  INTEGER;
           HORA_UNIT : in  INTEGER;
           HORA_DEZE : in  INTEGER;
			  ESTADO_ATUAL : in  INTEGER;
			  data : out STD_LOGIC_VECTOR(7 downto 0);
			  en : out STD_LOGIC;
			  rs : out STD_LOGIC
			);
			
end DISPLAY_LCD;

architecture ARQ_DISPLAY_LCD of DISPLAY_LCD is

signal H5, H4, H3, H2, H1, H0, CH1, CH2, CH3, CH4, CH5, CH6,
		 CH7, CH8, CH9, CH10, CH11: STD_LOGIC_VECTOR(7 downto 0);

begin
	
		with HORA_DEZE select
			H5 <= N0 when 0, N1 when 1, N2 when 2, N3 when 3, N4 when 4, N5 when 5,
					N6 when 6, N7 when 7, N8 when 8, N9 when  others;	
		with HORA_UNIT select
			H4 <= N0 when 0, N1 when 1, N2 when 2, N3 when 3, N4 when 4, N5 when 5,
					N6 when 6, N7 when 7, N8 when 8, N9 when  others;				
		with MINUTO_DEZE select
			H3 <= N0 when 0, N1 when 1, N2 when 2, N3 when 3, N4 when 4, N5 when 5,
					N6 when 6, N7 when 7, N8 when 8, N9 when  others;				
		with MINUTO_UNIT select
			H2 <= N0 when 0, N1 when 1, N2 when 2, N3 when 3, N4 when 4, N5 when 5,
					N6 when 6, N7 when 7, N8 when 8, N9 when  others;			
		with SEGUNDO_DEZE select
			H1 <= N0 when 0, N1 when 1, N2 when 2, N3 when 3, N4 when 4, N5 when 5,
					N6 when 6, N7 when 7, N8 when 8, N9 when  others;			
		with SEGUNDO_UNIT select
			H0 <= N0 when 0, N1 when 1, N2 when 2, N3 when 3, N4 when 4, N5 when 5,
					N6 when 6, N7 when 7, N8 when 8, N9 when  others;

codificacao: process(CLK_IN)
begin
	case ESTADO_ATUAL is
		--reset
		when 0 => CH1 <= LR; CH2 <= LE; CH3 <= LS; CH4 <= LE; CH5 <= LT; CH6 <= ESP;
					 CH7 <= ESP; CH8 <= ESP; CH9 <= ESP; CH10 <= ESP; CH11 <= ESP;
		--inicio
		when 1 => CH1 <= LI; CH2 <= LN; CH3 <= LI; CH4 <= LC; CH5 <= LI; CH6 <= LO;
					 CH7 <= ESP; CH8 <= ESP; CH9 <= ESP; CH10 <= ESP; CH11 <= ESP;	
		--programação
		when 2 => CH1 <= LP; CH2 <= LR; CH3 <= LO; CH4 <= LG; CH5 <= LR; CH6 <= LA;
					 CH7 <= LM; CH8 <= LA; CH9 <= LC; CH10 <= LA; CH11 <= LO;
		--contagem
		when 3 => CH1 <= LC; CH2 <= LO; CH3 <= LN; CH4 <= LT; CH5 <= LA; CH6 <= LG;
					 CH7 <= LE; CH8 <= LM; CH9 <= ESP; CH10 <= ESP; CH11 <= ESP;	
		--start
		when 4 => CH1 <= LS; CH2 <= LT; CH3 <= LA; CH4 <= LR; CH5 <= LT; CH6 <= ESP;
					 CH7 <= ESP; CH8 <= ESP; CH9 <= ESP; CH10 <= ESP; CH11 <= ESP;
		--stop
		when 5 => CH1 <= LS; CH2 <= LT; CH3 <= LO; CH4 <= LP; CH5 <= ESP; CH6 <= ESP;
					 CH7 <= ESP; CH8 <= ESP; CH9 <= ESP; CH10 <= ESP; CH11 <= ESP;
		--overflow
		when 6 => CH1 <= LC; CH2 <= LO; CH3 <= LN; CH4 <= LC; CH5 <= LL; CH6 <= LU;
					 CH7 <= LI; CH8 <= L_D; CH9 <= LO; CH10 <= ESP; CH11 <= ESP;	
		when others => null;
	end case;					
end process;	 


process(CLK_IN)

variable conta : INTEGER := 0;
variable conta_2 : INTEGER := 0;

begin		
	if(CLK_IN'event and CLK_IN = '1')then
		case conta is
			when 0 => rs <= '0'; conta := conta + 1; 		--configuração inicial
			
			when 1 => en <= '1'; conta := conta + 1;   
			when 2 => data <= conf_1; conta := conta + 1;  
			when 3 => en <= '0'; conta := conta + 1;
			
			when 4 => en <= '1'; conta := conta + 1;
			when 5 => data <= conf_2; conta := conta + 1;
			when 6 => en <= '0'; conta := conta + 1;
		
			when 7 => en <= '1'; conta := conta + 1;
			when 8 => data <= conf_3; conta := conta + 1;
			when 9 => en <= '0'; conta := conta + 1;
			
			when 10 => en <= '1'; conta := conta + 1;
			when 11 => data <= conf_4; conta := conta + 1;
			when 12 => en <= '0'; conta := conta + 1;
			
			when 13 => en <= '1'; conta := conta + 1;
			when 14 => rs <= '1'; conta_2 := 1; conta := 20; --termina configuração
			
			when others => null;
		end case;
		
		case conta_2 is
			when 1 => en <= '1'; conta_2 := conta_2 + 1; --posicionamento
			when 2 => rs <= '0'; conta_2 := conta_2 + 1;
			when 3 => data <= POS1; conta_2 := conta_2 + 1;
			when 4 => en <= '0'; conta_2 := conta_2 + 1;
			when 5 => en <= '1'; conta_2 := conta_2 + 1;
			when 6 => rs <= '1'; conta_2 := 19;
			
			when 19 => data <= H5; conta_2 := conta_2 + 1; --decimal da hora
			when 20 => en <= '0'; conta_2 := conta_2 + 1;
			when 21 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 22 => data <= H4; conta_2 := conta_2 + 1; --unitário da hora
			when 23 => en <= '0'; conta_2 := conta_2 + 1;
			when 24 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 25 => data <= DP; conta_2 := conta_2 + 1; --dois pontos
			when 26 => en <= '0'; conta_2 := conta_2 + 1;
			when 27 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 28 => data <= H3; conta_2 := conta_2 + 1; --decimal dos minutos
			when 29 => en <= '0'; conta_2 := conta_2 + 1;
			when 30 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 31 => data <= H2; conta_2 := conta_2 + 1; --unitário dos minutos
			when 32 => en <= '0'; conta_2 := conta_2 + 1;
			when 33 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 34 => data <= DP; conta_2 := conta_2 + 1; --dois pontos
			when 35 => en <= '0'; conta_2 := conta_2 + 1;
			when 36 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 37 => data <= H1; conta_2 := conta_2 + 1; --decimal dos segundos
			when 38 => en <= '0'; conta_2 := conta_2 + 1;
			when 39 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 40 => data <= H0; conta_2 := conta_2 + 1; --unitario dos segundos
			when 41 => en <= '0'; conta_2 := conta_2 + 1;
			when 42 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 43 => rs <= '0'; conta_2 := conta_2 + 1; --posicionamento
			when 44 => data <= POS2; conta_2 := conta_2 + 1;
			when 45 => en <= '0'; conta_2 := conta_2 + 1;
			when 46 => en <= '1'; conta_2 := conta_2 + 1;
			when 47 => rs <= '1'; conta_2 := conta_2 + 1; 
			
			when 48 => data <= LM; conta_2 := conta_2 + 1; --letra 'm'
			when 49 => en <= '0'; conta_2 := conta_2 + 1;
			when 50 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 51 => data <= LO; conta_2 := conta_2 + 1; --letra 'o'
			when 52 => en <= '0'; conta_2 := conta_2 + 1;
			when 53 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 54 => data <= L_D; conta_2 := conta_2 + 1; --letra 'd'
			when 55 => en <= '0'; conta_2 := conta_2 + 1;
			when 56 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 57 => data <= LO; conta_2 := conta_2 + 1; --letra 'o'
			when 58 => en <= '0'; conta_2 := conta_2 + 1;
			when 59 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 60 => data <= DP; conta_2 := conta_2 + 1; --dois pontos
			when 61 => en <= '0'; conta_2 := conta_2 + 1;
			when 62 => en <= '1'; conta_2 := 66;
			
			when 66 => data <= CH1; conta_2 := conta_2 + 1; --primeira letra do modo
			when 67 => en <= '0'; conta_2 := conta_2 + 1;
			when 68 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 69 => data <= CH2; conta_2 := conta_2 + 1; -- segunda letra do modo
			when 70 => en <= '0'; conta_2 := conta_2 + 1;
			when 71 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 72 => data <= CH3; conta_2 := conta_2 + 1; --terceira letra do modo
			when 73 => en <= '0'; conta_2 := conta_2 + 1;
			when 74 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 75 => data <= CH4; conta_2 := conta_2 + 1; --quarta letra do modo
			when 76 => en <= '0'; conta_2 := conta_2 + 1;
			when 77 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 78 => data <= CH5; conta_2 := conta_2 + 1; --quinta letra do modo
			when 79 => en <= '0'; conta_2 := conta_2 + 1;
			when 80 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 81 => data <= CH6; conta_2 := conta_2 + 1; --sexta letra do modo
			when 82 => en <= '0'; conta_2 := conta_2 + 1;
			when 83 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 84 => data <= CH7; conta_2 := conta_2 + 1; --setima letra do modo
			when 85 => en <= '0'; conta_2 := conta_2 + 1;
			when 86 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 87 => data <= CH8; conta_2 := conta_2 + 1; --oitava letra do modo
			when 88 => en <= '0'; conta_2 := conta_2 + 1;
			when 89 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 90 => data <= CH9; conta_2 := conta_2 + 1; --nona letra do modo
			when 91 => en <= '0'; conta_2 := conta_2 + 1;
			when 92 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 93 => data <= CH10; conta_2 := conta_2 + 1; --decima letra do modo
			when 94 => en <= '0'; conta_2 := conta_2 + 1;
			when 95 => en <= '1'; conta_2 := conta_2 + 1;
			
			when 96 => data <= CH11; conta_2 := conta_2 + 1; --última letra do modo
			when 97 => en <= '0'; conta_2 := conta_2 + 1;
			when 98 => conta_2 := 1;                         --fim do loop
						
			when others => null;
		end case;
	end if;

end process;	

end ARQ_DISPLAY_LCD;

