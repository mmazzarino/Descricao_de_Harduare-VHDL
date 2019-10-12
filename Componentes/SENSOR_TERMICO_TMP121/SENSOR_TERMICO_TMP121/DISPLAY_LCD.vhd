----------------------------------------------------------------------------------
-- Company: 
-- Engineer: M.M.
-- Create Date:    00:21:49 10/09/2018 
-- Design Name: 
-- Module Name:    DISPLAY_LCD - ARQ_DISPLAY_LCD 
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
	  POS2: STD_LOGIC_VECTOR(7 downto 0) := (x"c0");
	  GRAU: STD_LOGIC_VECTOR(7 downto 0) := (x"df")
	);
	
	
port ( 
  CLK_IN : in  STD_LOGIC;
  CLK2 : in  STD_LOGIC;
  TEMPERATURA : in  INTEGER;
  DATA : out STD_LOGIC_VECTOR(7 downto 0);
  EN : out STD_LOGIC;
  RS : out STD_LOGIC
);

end DISPLAY_LCD;

architecture ARQ_DISPLAY_LCD of DISPLAY_LCD is

signal tempA, tempB, tempC: INTEGER := 0;

signal temp_A, temp_B, temp_C: STD_LOGIC_VECTOR(7 downto 0); 

begin

process(CLK_IN)
variable A, B, C: INTEGER := 0;
begin

if(CLK_IN'event and CLK_IN = '1')then
	if(TEMPERATURA < 10)then
		tempA <= 0;
		tempB <= 0;
		tempC <= TEMPERATURA;
	elsif(TEMPERATURA >= 10) and (A < 10) and (A /= 0) and (B < 10) and (B /= 0) and (C < 10) and (C /= 0)then
		tempA <= A;
		tempB <= B;
		tempC <= C;
	elsif(TEMPERATURA >= 10) and (B = 0)then
		C := TEMPERATURA - 10;
		B := B + 1;
	elsif(C >= 10) and (B > 0)then
		C := C - 10;
		B := B + 1;
	elsif(C < 10) and (B /= 0)then
		if(B >= 10) and (A = 0)then
			B := B - 10;
			A := A + 1;
		elsif(B >= 10) and (A > 0)then
			B := B - 10;
			A := A + 1;
		end if;
	end if;
end if;
end process;	
	
	

--
-- for cont in 0 to 15 loop
--		if(C >= 10)then
--			C := C - 10;
--			B := B + 1;	
--		elsif(C < 10)then
--			tempC <= C;
--			if(B < 10)then 
--				tempB <= B;
--				tempA <= A;
--			elsif(B >= 10)then
--				for cont_2 in 0 to 5 loop
--					if(B > 10)then
--						B := B - 10;
--						A := A + 1;
--					end if;
--				end loop;
--			end if;
--		end if;
--end loop;	
--						
--
--	end loop;
--
--while (C >= 10) loop
--C := C - 10;
--B := B + 1;
--if(C < 10)then
--	tempC <= C;
--	if(B < 10)then 
--		tempB <= B;
--		tempA <= A;
--	elsif(B >= 10)then
--		while(B > 10)loop
--			B := B - 10;
--			A := A + 1;
--		end loop;
--	end if;
--end if;			
--end loop;


	


process(CLK2)

variable conta : INTEGER := 0;
variable conta_2 : INTEGER := 0;

begin		

if(CLK2'event and CLK2 = '1')then
case conta is
when 0 => RS <= '0'; conta := conta + 1; 		--configuração inicial

when 1 => EN <= '1'; conta := conta + 1;   
when 2 => DATA <= conf_1; conta := conta + 1;  
when 3 => EN <= '0'; conta := conta + 1;

when 4 => EN <= '1'; conta := conta + 1;
when 5 => DATA <= conf_2; conta := conta + 1;
when 6 => EN <= '0'; conta := conta + 1;

when 7 => EN <= '1'; conta := conta + 1;
when 8 => DATA <= conf_3; conta := conta + 1;
when 9 => EN <= '0'; conta := conta + 1;

when 10 => EN <= '1'; conta := conta + 1;
when 11 => DATA <= conf_4; conta := conta + 1;
when 12 => EN <= '0'; conta := conta + 1;

when 13 => EN <= '1'; conta := conta + 1;
when 14 => RS <= '1'; conta_2 := 1; conta := 20; --termina configuração

when others => null;
end case;

case conta_2 is
when 1 => EN <= '1'; conta_2 := conta_2 + 1; --posicionamento
when 2 => RS <= '0'; conta_2 := conta_2 + 1;
when 3 => DATA <= POS1; conta_2 := conta_2 + 1;
when 4 => EN <= '0'; conta_2 := conta_2 + 1;
when 5 => EN <= '1'; conta_2 := conta_2 + 1;
when 6 => RS <= '1'; conta_2 := conta_2 + 1;

when 7 => DATA <= LT; conta_2 := conta_2 + 1; --T
when 8 => EN <= '0'; conta_2 := conta_2 + 1;
when 9 => EN <= '1'; conta_2 := conta_2 + 1;

when 10 => DATA <= LE; conta_2 := conta_2 + 1; --E
when 11 => EN <= '0'; conta_2 := conta_2 + 1;
when 12 => EN <= '1'; conta_2 := conta_2 + 1;

when 13 => DATA <= LM; conta_2 := conta_2 + 1; --M
when 14 => EN <= '0'; conta_2 := conta_2 + 1;
when 15 => EN <= '1'; conta_2 := conta_2 + 1;

when 16 => DATA <= LP; conta_2 := conta_2 + 1; --P
when 17 => EN <= '0'; conta_2 := conta_2 + 1;
when 18 => EN <= '1'; conta_2 := conta_2 + 1;

when 19 => DATA <= LE; conta_2 := conta_2 + 1; --E
when 20 => EN <= '0'; conta_2 := conta_2 + 1;
when 21 => EN <= '1'; conta_2 := conta_2 + 1;

when 22 => DATA <= LR; conta_2 := conta_2 + 1; --R
when 23 => EN <= '0'; conta_2 := conta_2 + 1;
when 24 => EN <= '1'; conta_2 := conta_2 + 1;

when 25 => DATA <= LA; conta_2 := conta_2 + 1; --A
when 26 => EN <= '0'; conta_2 := conta_2 + 1;
when 27 => EN <= '1'; conta_2 := conta_2 + 1;

when 28 => DATA <= LT; conta_2 := conta_2 + 1; --T
when 29 => EN <= '0'; conta_2 := conta_2 + 1;
when 30 => EN <= '1'; conta_2 := conta_2 + 1;

when 31 => DATA <= LU; conta_2 := conta_2 + 1; --U
when 32 => EN <= '0'; conta_2 := conta_2 + 1;
when 33 => EN <= '1'; conta_2 := conta_2 + 1;

when 34 => DATA <= LR; conta_2 := conta_2 + 1; --R
when 35 => EN <= '0'; conta_2 := conta_2 + 1;
when 36 => EN <= '1'; conta_2 := conta_2 + 1;

when 37 => DATA <= LA; conta_2 := conta_2 + 1; --A
when 38 => EN <= '0'; conta_2 := conta_2 + 1;
when 39 => EN <= '1'; conta_2 := conta_2 + 1;

when 40 => DATA <= DP; conta_2 := conta_2 + 1; --:
when 41 => EN <= '0'; conta_2 := conta_2 + 1;
when 42 => EN <= '1'; conta_2 := conta_2 + 1;

when 43 => RS <= '0'; conta_2 := conta_2 + 1; --posiciona na 2ª linha
when 44 => DATA <= POS2; conta_2 := conta_2 + 1;
when 45 => EN <= '0'; conta_2 := conta_2 + 1;
when 46 => EN <= '1'; conta_2 := conta_2 + 1;
when 47 => RS <= '1'; conta_2 := conta_2 + 1; 

when 48 => DATA <= temp_A; conta_2 := conta_2 + 1; --centena da tenperatura
when 49 => EN <= '0'; conta_2 := conta_2 + 1;
when 50 => EN <= '1'; conta_2 := conta_2 + 1;

when 51 => DATA <= temp_B; conta_2 := conta_2 + 1; --dezena da teperatura
when 52 => EN <= '0'; conta_2 := conta_2 + 1;
when 53 => EN <= '1'; conta_2 := conta_2 + 1;

when 54 => DATA <= temp_C; conta_2 := conta_2 + 1; --unidade da temperatura
when 55 => EN <= '0'; conta_2 := conta_2 + 1;
when 56 => EN <= '1'; conta_2 := conta_2 + 1;

when 57 => DATA <= GRAU; conta_2 := conta_2 + 1; --º
when 58 => EN <= '0'; conta_2 := conta_2 + 1;
when 59 => EN <= '1'; conta_2 := conta_2 + 1;

when 60 => DATA <= ESP; conta_2 := conta_2 + 1; --espaço
when 61 => EN <= '0'; conta_2 := conta_2 + 1;
when 62 => EN <= '1'; conta_2 := conta_2 + 1;

when 66 => DATA <= LC; conta_2 := conta_2 + 1; --C
when 67 => EN <= '0'; conta_2 := conta_2 + 1;
when 68 => EN <= '1'; conta_2 := conta_2 + 1;

when 69 => DATA <= LE; conta_2 := conta_2 + 1; --E
when 70 => EN <= '0'; conta_2 := conta_2 + 1;
when 71 => EN <= '1'; conta_2 := conta_2 + 1;

when 72 => DATA <= LL; conta_2 := conta_2 + 1; --L
when 73 => EN <= '0'; conta_2 := conta_2 + 1;
when 74 => EN <= '1'; conta_2 := conta_2 + 1;

when 75 => DATA <= LC; conta_2 := conta_2 + 1; --C
when 76 => EN <= '0'; conta_2 := conta_2 + 1;
when 77 => EN <= '1'; conta_2 := conta_2 + 1;

when 78 => DATA <= LI; conta_2 := conta_2 + 1; --I
when 79 => EN <= '0'; conta_2 := conta_2 + 1;
when 80 => EN <= '1'; conta_2 := conta_2 + 1;

when 81 => DATA <= LO; conta_2 := conta_2 + 1; --O
when 82 => EN <= '0'; conta_2 := conta_2 + 1;
when 83 => EN <= '1'; conta_2 := conta_2 + 1;

when 84 => DATA <= LS; conta_2 := conta_2 + 1; --S
when 85 => EN <= '0'; conta_2 := conta_2 + 1;
when 86 => EN <= '1'; conta_2 := 1;

when others => null;
end case;



end if;


end process;	

end ARQ_DISPLAY_LCD;
