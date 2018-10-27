	----------------------------------------------------------------------------------
	-- Company: 
	-- Engineer: 
	-- Create Date:    21:43:19 10/08/2018 
	-- Design Name: 
	-- Module Name:    MAIN_CRONOMETRO - ARQ_MAIN_CRONOMETRO 
	-- Project Name: 
	-- Target Devices: 
	-- Tool versions: 
	-- Description: 
	-- Dependencies: 
	-- Revision: 
	-- Revision 0.01 - File Created
	-- Additional Comments: 
	----------------------------------------------------------------------------------
	library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.STD_LOGIC_UNSIGNED.ALL;
	use IEEE.NUMERIC_STD.ALL;
	use IEEE.STD_LOGIC_ARITH.ALL ;  

	entity MAIN_CRONOMETRO is  
		Port (  CLK : in  STD_LOGIC;
				  STOP_START : in  STD_LOGIC;
				  UP_DOWN : in  STD_LOGIC;
				  RESET : in  STD_LOGIC;
				  PROG_CONT : in  STD_LOGIC;
				  VEL1_VEL2 : in  STD_LOGIC;
				  AJUSTE_TEMPO : in  STD_LOGIC_VECTOR (3 downto 0);
				  EN_LCD : out  STD_LOGIC;
				  RS_LCD : out  STD_LOGIC;
				  DADOS_LCD : out  STD_LOGIC_VECTOR (7 downto 0)
				);
				
	end MAIN_CRONOMETRO;

		architecture ARQ_MAIN_CRONOMETRO of MAIN_CRONOMETRO is
	--declaração de constantes
	constant HIGH_1HZ: INTEGER := 25_000_000;
	constant TOTAL_1HZ: INTEGER := 50_000_000;
	constant HIGH_10HZ: INTEGER := 2_500_000;
	constant TOTAL_10HZ: INTEGER := 5_000_000;
	constant HIGH_625HZ: INTEGER := 40_000;
	constant TOTAL_625HZ: INTEGER := 80_000;
	constant HIGH_3HZ: INTEGER := 8_000_000;
	constant TOTAL_3HZ: INTEGER := 16_000_000;

	--declaração dos componentes
	component DIVISOR_CLOCK
		Port (
				CLK_IN: in STD_LOGIC; 
				CONT_HIGH: in INTEGER; 
				CONT_TOTAL: in INTEGER; 
				CLK_OUT: out STD_LOGIC);
	end component; 
	
	component DISPLAY_LCD
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
	end component;

	--definição de tipos
	type ESTADOS_PRIMARIOS is (inicio, programacao, contagem, start, reseta, stop, overFlow);
	type ESTADOS_CONTAGEM is (crescente_1hz, crescente_10hz, decrescente_1hz, decrescente_10hz);
	type ESTADOS_AJUSTE_HORA is (hora_decimal, hora_unitario, minuto_decimal, minuto_unitario, segundo_decimal, segundo_unitario);
	type HORA is array (5 downto 0) of INTEGER range 0 to 9;

	--declaração de sinais de tipos
	signal estado_primario_atual, estado_primario_futuro : ESTADOS_PRIMARIOS := inicio;
	signal estado_contagem : ESTADOS_CONTAGEM;
	signal estado_ajuste_atual, estado_ajuste_futuro : ESTADOS_AJUSTE_HORA;
	signal tempo_maximo : HORA;
	signal tempo_minimo : HORA;
	signal recebe_ajuste : HORA := (2, 3, 5, 9, 5, 9);
	signal hora_agora_1hz : HORA := (0, 0, 0, 0, 0, 0);
	signal hora_agora_10hz : HORA;	
	signal recebe_hora_agora : HORA;
   signal enum_estado: INTEGER; 
	signal estado_overFlow_1hz : BOOLEAN := FALSE;
	signal estado_overFlow_10hz : BOOLEAN := FALSE;
	signal clock1hz, clock10hz, clock625hz, clock3hz: STD_LOGIC;
	signal ajustar_tempo: STD_LOGIC_VECTOR (3 downto 0);
	signal concatenacao: STD_LOGIC_VECTOR (1 downto 0);
	begin
		
										
	--instanciações de componentes
		clock_1hz: DIVISOR_CLOCK port map (CLK_IN => CLK, CONT_HIGH => HIGH_1HZ, CONT_TOTAL => TOTAL_1HZ, CLK_OUT => clock1hz);
		
		clock_10hz: DIVISOR_CLOCK port map (CLK_IN => CLK, CONT_HIGH => HIGH_10HZ, CONT_TOTAL => TOTAL_10HZ, CLK_OUT => clock10hz);
		
		clock_625hz: DIVISOR_CLOCK port map (CLK_IN => CLK, CONT_HIGH => HIGH_625HZ, CONT_TOTAL => TOTAL_625HZ, CLK_OUT => clock625hz);
		
		clock_3hz: DIVISOR_CLOCK port map (CLK_IN => CLK, CONT_HIGH => HIGH_3HZ, CONT_TOTAL => TOTAL_3HZ, CLK_OUT => clock3hz);

		lcd: DISPLAY_LCD port map (
			  CLK_IN => clock625hz,   
           SEGUNDO_UNIT => recebe_hora_agora(0),
           SEGUNDO_DEZE => recebe_hora_agora(1),
           MINUTO_UNIT => recebe_hora_agora(2),
           MINUTO_DEZE => recebe_hora_agora(3),
           HORA_UNIT => recebe_hora_agora(4),
           HORA_DEZE => recebe_hora_agora(5),
			  ESTADO_ATUAL => enum_estado,
			  data => DADOS_LCD,
			  en => EN_LCD,
			  rs => RS_LCD
			);
		
	--INÍCIO---------------------------------------------------------------
	
	transicao_de_estados_primarios :process(CLK, STOP_START, RESET, PROG_CONT)
	begin

		concatenacao <= VEL1_VEL2 & PROG_CONT;
		
		case concatenacao is
			when "01" => recebe_hora_agora <= hora_agora_1hz;
			when "11" => recebe_hora_agora <= hora_agora_10hz;
			when others => recebe_hora_agora <= recebe_ajuste;
		end case;
		
	estado_primario_futuro <= estado_primario_atual;
		
		if(RESET = '1')then
		enum_estado <= 0;
		estado_primario_futuro <= reseta;
		else	
			case estado_primario_atual is
				when inicio =>
					enum_estado <= 1;
					if(PROG_CONT = '0')then estado_primario_futuro <= programacao;
					elsif(PROG_CONT = '1')then estado_primario_futuro <= contagem;
					end if;
				when programacao =>
					enum_estado <= 2;
					if(PROG_CONT = '1')then estado_primario_futuro <= contagem;
					end if;
				when contagem =>
					enum_estado <= 3;
					if(PROG_CONT = '0')then estado_primario_futuro <= programacao;
					elsif(STOP_START = '1')then estado_primario_futuro <= start;
					end if;
				when start =>
					enum_estado <= 4;
					if(STOP_START = '0')then estado_primario_futuro <= stop;
					elsif(estado_overFlow_1hz or estado_overFlow_10hz)then estado_primario_futuro <= overFlow;
					end if;
				when stop =>
					enum_estado <= 5;
					if(STOP_START = '1')then estado_primario_futuro <= start;
					elsif(PROG_CONT = '0')then estado_primario_futuro <= programacao;
					end if;
				when overFlow =>
					enum_estado <= 6;
					if(PROG_CONT = '0')then estado_primario_futuro <= programacao;
					elsif(STOP_START = '0')then estado_primario_futuro <= stop;
					end if;
				when reseta => estado_primario_futuro <= inicio;
					

				when others => null;
			end case;
		end if;
		
	end process;

	transicao_de_estados_configuracao: process(CLK, UP_DOWN, VEL1_VEL2)
	variable concatena: STD_LOGIC_VECTOR (1 downto 0);
	begin
	concatena := UP_DOWN & VEL1_VEL2;
		if(estado_primario_atual = programacao)then
			case concatena is
				when "00" => estado_contagem <= crescente_1hz;
				when "10" => estado_contagem <= decrescente_1hz;
				when "01" => estado_contagem <= crescente_10hz;
				when "11" => estado_contagem <= decrescente_10hz;
				when others => null;
			end case;
		end if;
	end process;


	transicao_de_estados_ajuste: process(clock10hz)
	begin	
	
	if(clock10hz'event and clock10hz = '1')then
	estado_ajuste_futuro <= estado_ajuste_atual;
		
				if(AJUSTE_TEMPO = "1000")then ajustar_tempo <= "1000";
			elsif(AJUSTE_TEMPO = "0100")then ajustar_tempo <= "0100";
			elsif(AJUSTE_TEMPO = "0010")then ajustar_tempo <= "0010";
			elsif(AJUSTE_TEMPO = "0001")then ajustar_tempo <= "0001";
			elsif(AJUSTE_TEMPO = "0000")then ajustar_tempo <= "0000";
			else null;
			end if;
		
		if(RESET = '1')then
			recebe_ajuste <= (2, 3, 5, 9, 5, 9);
		elsif(estado_primario_atual = programacao)then	
			case ajustar_tempo is
				when "1000" => 
					case estado_ajuste_atual is
						when hora_decimal => estado_ajuste_futuro <= hora_unitario; ajustar_tempo <= "0000";
						when hora_unitario => estado_ajuste_futuro <= minuto_decimal; ajustar_tempo <= "0000";
						when minuto_decimal => estado_ajuste_futuro <= minuto_unitario; ajustar_tempo <= "0000";
						when minuto_unitario => estado_ajuste_futuro <= segundo_decimal; ajustar_tempo <= "0000";
						when segundo_decimal => estado_ajuste_futuro <= segundo_unitario; ajustar_tempo <= "0000";
						when segundo_unitario => estado_ajuste_futuro <= hora_decimal; ajustar_tempo <= "0000";
						when others => null;
					end case;
				when "0100" =>
					case estado_ajuste_atual is
						when hora_decimal => estado_ajuste_futuro <= segundo_unitario; ajustar_tempo <= "0000";
						when hora_unitario => estado_ajuste_futuro <= hora_decimal; ajustar_tempo <= "0000";
						when minuto_decimal => estado_ajuste_futuro <= hora_unitario; ajustar_tempo <= "0000";
						when minuto_unitario => estado_ajuste_futuro <= minuto_decimal; ajustar_tempo <= "0000";
						when segundo_decimal => estado_ajuste_futuro <= minuto_unitario; ajustar_tempo <= "0000";
						when segundo_unitario => estado_ajuste_futuro <= segundo_decimal; ajustar_tempo <= "0000";
						when others => null;
						
					end case;					
				when "0010" => 
					case estado_ajuste_atual is
						when hora_decimal => ajustar_tempo <= "0000";
							if(recebe_ajuste(5) < 2)then recebe_ajuste(5)<= recebe_ajuste(5) + 1; else recebe_ajuste(5)<= 0; end if;
						when hora_unitario => ajustar_tempo <= "0000";
							if(recebe_ajuste(4) < 3)then recebe_ajuste(4)<= recebe_ajuste(4) + 1; else recebe_ajuste(4)<= 0; end if;
						when minuto_decimal => ajustar_tempo <= "0000";
							if(recebe_ajuste(3) < 5)then recebe_ajuste(3)<= recebe_ajuste(3) + 1; else recebe_ajuste(3) <= 0; end if;
						when minuto_unitario =>  ajustar_tempo <= "0000";
							if(recebe_ajuste(2) < 9)then recebe_ajuste(2)<= recebe_ajuste(2) + 1; else recebe_ajuste(2) <= 0; end if;
						when segundo_decimal => ajustar_tempo <= "0000";
							if(recebe_ajuste(1) < 5)then recebe_ajuste(1)<= recebe_ajuste(1) + 1; else recebe_ajuste(1) <= 0; end if;
						when segundo_unitario => ajustar_tempo <= "0000";
							if(recebe_ajuste(0) < 9)then recebe_ajuste(0)<= recebe_ajuste(0) + 1; else recebe_ajuste(0) <= 0; end if;
						when others => null;
					end case;					
				when "0001" =>
					case estado_ajuste_atual is
						when hora_decimal => ajustar_tempo <= "0000";
							if(recebe_ajuste(5) > 0)then recebe_ajuste(5)<= recebe_ajuste(5) - 1; else recebe_ajuste(5)<= 2; end if;
						when hora_unitario => ajustar_tempo <= "0000";
							if(recebe_ajuste(4) > 0)then recebe_ajuste(4)<= recebe_ajuste(4) - 1; else recebe_ajuste(4)<= 3; end if;
						when minuto_decimal => ajustar_tempo <= "0000";
							if(recebe_ajuste(3) > 0)then recebe_ajuste(3)<= recebe_ajuste(3) - 1; else recebe_ajuste(3) <= 5; end if;
						when minuto_unitario => ajustar_tempo <= "0000";
							if(recebe_ajuste(2) > 0)then recebe_ajuste(2)<= recebe_ajuste(2) - 1; else recebe_ajuste(2) <= 9; end if;
						when segundo_decimal => ajustar_tempo <= "0000";
							if(recebe_ajuste(1) > 0)then recebe_ajuste(1)<= recebe_ajuste(1) - 1; else recebe_ajuste(1) <= 5; end if;
						when segundo_unitario => ajustar_tempo <= "0000";
							if(recebe_ajuste(0) > 0)then recebe_ajuste(0)<= recebe_ajuste(0) - 1; else recebe_ajuste(0) <= 9; end if;
						when others => null;
					end case;
				when others => null;
			end case;
		end if;
	end if;	
	end process;





	flip_flop: process
	begin
		wait until CLK'event and CLK = '1';
		estado_primario_atual <= estado_primario_futuro;
		estado_ajuste_atual <= estado_ajuste_futuro;
	end process;
		
		
		
		
		
	Execucao_1hz: process(clock1hz, estado_primario_atual, estado_ajuste_atual, estado_contagem)
	variable saida_hora_crescente: HORA := (0, 0, 0, 0, 0, 0);
	variable saida_hora_decrescente: HORA := (2, 3, 5, 9, 5, 9);

	begin
		if(clock1hz'event and clock1hz ='1')then
			case estado_primario_atual is
				when overFlow =>
					saida_hora_crescente := saida_hora_crescente;
					saida_hora_decrescente := saida_hora_decrescente;
				when stop =>
					saida_hora_crescente := saida_hora_crescente;
					saida_hora_decrescente := saida_hora_decrescente;
				when reseta => 
					estado_overFlow_1hz <= FALSE;
					saida_hora_crescente := (0, 0, 0, 0, 0, 0);
					saida_hora_decrescente := (2, 3, 5, 9, 5, 9);			
				when start =>					
					case estado_contagem is
						when crescente_1hz => if(RESET = '1')then saida_hora_crescente := (0, 0, 0, 0, 0, 0); end if;
							hora_agora_1hz <= saida_hora_crescente;					
								if(saida_hora_crescente = recebe_ajuste)then estado_overFlow_1hz <= TRUE; else estado_overFlow_1hz <= FALSE;					
									if(saida_hora_crescente(0) < 9)then
										saida_hora_crescente(0) := saida_hora_crescente(0) + 1;
									else
										saida_hora_crescente(0) := 0;
										if(saida_hora_crescente(1) < 5)then
											saida_hora_crescente(1) := saida_hora_crescente(1) + 1;
										else
											saida_hora_crescente(1) := 0;
											if(saida_hora_crescente(2) < 9)then
												saida_hora_crescente(2) := saida_hora_crescente(2) + 1;
											else
												saida_hora_crescente(2) := 0;
												if(saida_hora_crescente(3) < 5)then
													saida_hora_crescente(3) := saida_hora_crescente(3) + 1;
												else
													saida_hora_crescente(3) := 0;
													if(saida_hora_crescente(4) < 3)then
														saida_hora_crescente(4) := saida_hora_crescente(4) + 1;
													else
														saida_hora_crescente(4) := 0;
														if(saida_hora_crescente(5) < 2)then
															saida_hora_crescente(5) := saida_hora_crescente(5) + 1;
														else
															saida_hora_crescente(5) := 2;												
														end if;
													end if;
												end if;
											end if;
										end if;
									end if;						
								end if;
							
									
						when decrescente_1hz => if(RESET = '1')then saida_hora_decrescente := (2, 3, 5, 9, 5, 9); end if;
							hora_agora_1hz <= saida_hora_decrescente;
							if(saida_hora_decrescente = (2, 3, 5, 9, 5, 9))then
								saida_hora_decrescente := recebe_ajuste; 
								elsif(saida_hora_decrescente = (0, 0, 0, 0, 0, 0))then
								estado_overFlow_1hz <= TRUE;
							end if;						
									if(saida_hora_decrescente(0) > 0)then
										saida_hora_decrescente(0) := saida_hora_decrescente(0) - 1;
									else
										saida_hora_decrescente(0) := 9;
										if(saida_hora_decrescente(1) > 0)then
											saida_hora_decrescente(1) := saida_hora_decrescente(1) - 1;
										else
											saida_hora_decrescente(1) := 5;
											if(saida_hora_decrescente(2) > 0)then
												saida_hora_decrescente(2) := saida_hora_decrescente(2) - 1;
											else
												saida_hora_decrescente(2) := 9;
												if(saida_hora_decrescente(3) > 0)then
													saida_hora_decrescente(3) := saida_hora_decrescente(3) - 1;
												else
													saida_hora_decrescente(3) := 5;
													if(saida_hora_decrescente(4) > 0)then
														saida_hora_decrescente(4) := saida_hora_decrescente(4) - 1;
													else
														saida_hora_decrescente(4) := 3;
														if(saida_hora_decrescente(5) > 0)then
															saida_hora_decrescente(5) := saida_hora_decrescente(5) - 1;
														else
															saida_hora_decrescente(5) := 0;
															
														end if;
													end if;
												end if;									
										end if;						
									end if;
								end if;						
							when others => null;
						
						if(saida_hora_decrescente = (0, 0, 0, 0, 0, 0))then
						estado_overFlow_1hz <= TRUE;	
					end if;end case;					
				when others => null;				
			end case;
		end if;
	end process;
						

	Execucao_10hz: process(clock10hz, estado_primario_atual, estado_ajuste_atual, estado_contagem)
	variable saida_hora_crescente: HORA := (0, 0, 0, 0, 0, 0);
	variable saida_hora_decrescente: HORA := (2, 3, 5, 9, 5, 9);

	begin
		if(clock10hz'event and clock10hz ='1')then
			case estado_primario_atual is
				when overFlow =>
					saida_hora_crescente := saida_hora_crescente;
					saida_hora_decrescente := saida_hora_decrescente;
				when stop =>
					saida_hora_crescente := saida_hora_crescente;
					saida_hora_decrescente := saida_hora_decrescente;
				when reseta => 
					estado_overFlow_10hz <= FALSE;
					saida_hora_crescente := (0, 0, 0, 0, 0, 0);
					saida_hora_decrescente := (2, 3, 5, 9, 5, 9);
				when start =>					
					case estado_contagem is
						when crescente_10hz => if(RESET = '1')then saida_hora_crescente := (0, 0, 0, 0, 0, 0); end if;
							hora_agora_10hz <= saida_hora_crescente;						
								if(saida_hora_crescente = recebe_ajuste)then estado_overFlow_10hz <= TRUE; else  estado_overFlow_10hz <= FALSE;						
									if(saida_hora_crescente(0) < 9)then
										saida_hora_crescente(0) := saida_hora_crescente(0) + 1;
									else
										saida_hora_crescente(0) := 0;
										if(saida_hora_crescente(1) < 5)then
											saida_hora_crescente(1) := saida_hora_crescente(1) + 1;
										else
											saida_hora_crescente(1) := 0;
											if(saida_hora_crescente(2) < 9)then
												saida_hora_crescente(2) := saida_hora_crescente(2) + 1;
											else
												saida_hora_crescente(2) := 0;
												if(saida_hora_crescente(3) < 5)then
													saida_hora_crescente(3) := saida_hora_crescente(3) + 1;
												else
													saida_hora_crescente(3) := 0;
													if(saida_hora_crescente(4) < 3)then
														saida_hora_crescente(4) := saida_hora_crescente(4) + 1;
													else
														saida_hora_crescente(4) := 0;
														if(saida_hora_crescente(5) < 2)then
															saida_hora_crescente(5) := saida_hora_crescente(5) + 1;
														else
															saida_hora_crescente(5) := 2;												
														end if;
													end if;
												end if;
											end if;
										end if;
									end if;						
								end if;
								
							
						when decrescente_10hz => if(RESET = '1')then saida_hora_decrescente := (2, 3, 5, 9, 5, 9); end if;
							hora_agora_10hz <= saida_hora_decrescente;
							if(saida_hora_decrescente = (2, 3, 5, 9, 5, 9))then
								saida_hora_decrescente := recebe_ajuste; 
							elsif(saida_hora_decrescente = (0, 0, 0, 0, 0, 0))then
								estado_overFlow_10hz <= TRUE;
							end if;								
									if(saida_hora_decrescente(0) > 0)then
										saida_hora_decrescente(0) := saida_hora_decrescente(0) - 1;
									else
										saida_hora_decrescente(0) := 9;
										if(saida_hora_decrescente(1) > 0)then
											saida_hora_decrescente(1) := saida_hora_decrescente(1) - 1;
										else
											saida_hora_decrescente(1) := 5;
											if(saida_hora_decrescente(2) > 0)then
												saida_hora_decrescente(2) := saida_hora_decrescente(2) - 1;
											else
												saida_hora_decrescente(2) := 9;
												if(saida_hora_decrescente(3) > 0)then
													saida_hora_decrescente(3) := saida_hora_decrescente(3) - 1;
												else
													saida_hora_decrescente(3) := 5;
													if(saida_hora_decrescente(4) > 0)then
														saida_hora_decrescente(4) := saida_hora_decrescente(4) - 1;
													else
														saida_hora_decrescente(4) := 3;
														if(saida_hora_decrescente(5) > 0)then
															saida_hora_decrescente(5) := saida_hora_decrescente(5) - 1;
														else
															saida_hora_decrescente(5) := 0;
															
															end if;
														end if;
													end if;
												end if;
											end if;
										end if;						
															
								when others => null;
							if(saida_hora_decrescente = (0, 0, 0, 0, 0, 0))then
									estado_overFlow_10hz <= TRUE;
							end if;	
							end case;							
					when others => null;							
			end case;
		end if;
	end process;				
		

		
	
	end ARQ_MAIN_CRONOMETRO;