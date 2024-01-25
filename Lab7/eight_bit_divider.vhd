LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY eight_bit_divider IS
	PORT( clk, reset : IN STD_LOGIC;
			Divisor, Dividend : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Remainder : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0);
			Q  : BUFFER std_logic_vector(7 downto 0);
			seg_QH, seg_QL, seg_RH, seg_RL : OUT STD_LOGIC_VECTOR(0 TO 6);
			seg_count, seg_step : OUT STD_LOGIC_VECTOR(0 TO 6)
		);
END eight_bit_divider;

ARCHITECTURE logicFunc OF eight_bit_divider IS
	COMPONENT hex IS
		PORT (
			w, x, y, z : IN STD_LOGIC;
			a, b, c, d, e, f, g : OUT STD_LOGIC);
	END COMPONENT;
	
	TYPE state_type IS (Start, S1, S2a, S2b, S3, S4);
	SIGNAL y : state_type;
	SIGNAL Count : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Divs : STD_LOGIC_VECTOR(15 DOWNTO 0);
	shared variable tmp : std_logic_vector(15 downto 0);
	
BEGIN

	--狀態機
	PROCESS(reset, clk)
   BEGIN
		IF reset = '1' THEN
			-- initialize
			Remainder <= (others => '0');
			Q <= (others => '0');
			Divs <= (others => '0');
			Count <= (others => '0');
			
			seg_QH <= (others => '1');
			seg_QL <= (others => '1');
			seg_RH <= (others => '1');
			seg_RL <= (others => '1');
					
			y <= Start;
		ELSIF clk'EVENT AND clk = '1' THEN
			CASE y IS
				WHEN Start =>
					--Reset remainder, divisor, quotient
					Remainder <= "00000000" & Dividend;
					Q <= (others => '0');
					Divs <= Divisor & "00000000";
					Count <= "0001";
					
					y <= S1;
				WHEN S1 =>
					-- subtract divisor reg from remainder reg, and place the result in remainder reg
					-- if remainder >= 0 to S2a, otherwise to S2b	
					Remainder <= Remainder - Divs; -- 減法運算
					tmp := Remainder - Divs; 
					IF tmp(15) = '1' THEN  -- 確定餘數符號
						y <= S2b;
					ELSE
						y <= S2a;
					END IF;
	
				WHEN S2a =>
					-- shift quotient reg to left, setting new LSB bit to 1
					Q <= Q(6 DOWNTO 0) & '1';
					y <= S3;
				WHEN S2b =>
					-- Restoring: adding divisor to remainder, place the sum back to remainder
					-- , shift quotient to the left, setting new LSB to 0 
					Remainder <= Remainder + Divs;
					Q <= Q(6 DOWNTO 0) & '0';
					-- w is don't care in this step, so no need to assign value to w
					y <= S3;	
				WHEN S3 =>
					-- shift divisor reg right 1 bit
					Divs <= '0' & Divs(15 DOWNTO 1);
					-- determine the procedure is end or not(=9 to S4)(<9 to S1)
					IF Count >= "1001" THEN
						y <= S4;
					ELSE
						Count <= Count + "0001";
						y <= S1;
					END IF;
				WHEN S4 =>
					--seven_QH : hex PORT MAP(Q(7), Q(6), Q(5), Q(4), seg_QH(0), seg_QH(1), seg_QH(2), seg_QH(3), seg_QH(4), seg_QH(5), seg_QH(6));
					--seven_QL : hex PORT MAP(Q(3), Q(2), Q(1), Q(0), seg_QL(0), seg_QL(1), seg_QL(2), seg_QL(3), seg_QL(4), seg_QL(5), seg_QL(6));
					--seven_RH : hex PORT MAP(Remain(7), Remain(6), Remain(5), Remain(4), seg_RH(3), seg_RH(1), seg_RH(2), seg_RH(3), seg_RH(4), seg_RH(5), seg_RH(6));
					--seven_RL : hex PORT MAP(Remain(3), Remain(2), Remain(1), Remain(0), seg_RL(0), seg_RL(1), seg_RL(2), seg_RL(3), seg_RL(4), seg_RL(5), seg_RL(6));
					CASE Q(7 DOWNTO 4) is
						WHEN "0000" => seg_QH <= "0000001";
						WHEN "0001" => seg_QH <= "1001111";
						WHEN "0010" => seg_QH <= "0010010";
						WHEN "0011" => seg_QH <= "0000110";
						WHEN "0100" => seg_QH <= "1001100";
						WHEN "0101" => seg_QH <= "0100100";
						WHEN "0110" => seg_QH <= "0100000";
						WHEN "0111" => seg_QH <= "0001111";
						WHEN "1000" => seg_QH <= "0000000";
						WHEN "1001" => seg_QH <= "0001100";
						WHEN "1010" => seg_QH <= "0001000";
						WHEN "1011" => seg_QH <= "1100000";
						WHEN "1100" => seg_QH <= "1110010";
						WHEN "1101" => seg_QH <= "1000010";
						WHEN "1110" => seg_QH <= "0110000";
						WHEN "1111" => seg_QH <= "0111000";
						WHEN others => seg_QH <= "1111111";
					end CASE;
					
					CASE Q(3 DOWNTO 0) is
						WHEN "0000" => seg_QL <= "0000001";
						WHEN "0001" => seg_QL <= "1001111";
						WHEN "0010" => seg_QL <= "0010010";
						WHEN "0011" => seg_QL <= "0000110";
						WHEN "0100" => seg_QL <= "1001100";
						WHEN "0101" => seg_QL <= "0100100";
						WHEN "0110" => seg_QL <= "0100000";
						WHEN "0111" => seg_QL <= "0001111";
						WHEN "1000" => seg_QL <= "0000000";
						WHEN "1001" => seg_QL <= "0001100";
						WHEN "1010" => seg_QL <= "0001000";
						WHEN "1011" => seg_QL <= "1100000";
						WHEN "1100" => seg_QL <= "1110010";
						WHEN "1101" => seg_QL <= "1000010";
						WHEN "1110" => seg_QL <= "0110000";
						WHEN "1111" => seg_QL <= "0111000";
						WHEN others => seg_QL <= "1111111";
					end CASE;
					
					CASE Remainder(7 DOWNTO 4) is
						WHEN "0000" => seg_RH <= "0000001";
						WHEN "0001" => seg_RH <= "1001111";
						WHEN "0010" => seg_RH <= "0010010";
						WHEN "0011" => seg_RH <= "0000110";
						WHEN "0100" => seg_RH <= "1001100";
						WHEN "0101" => seg_RH <= "0100100";
						WHEN "0110" => seg_RH <= "0100000";
						WHEN "0111" => seg_RH <= "0001111";
						WHEN "1000" => seg_RH <= "0000000";
						WHEN "1001" => seg_RH <= "0001100";
						WHEN "1010" => seg_RH <= "0001000";
						WHEN "1011" => seg_RH <= "1100000";
						WHEN "1100" => seg_RH <= "1110010";
						WHEN "1101" => seg_RH <= "1000010";
						WHEN "1110" => seg_RH <= "0110000";
						WHEN "1111" => seg_RH <= "0111000";
						WHEN others => seg_RH <= "1111111";
					end CASE;
					
					CASE Remainder(3 DOWNTO 0) is
						WHEN "0000" => seg_RL <= "0000001";
						WHEN "0001" => seg_RL <= "1001111";
						WHEN "0010" => seg_RL <= "0010010";
						WHEN "0011" => seg_RL <= "0000110";
						WHEN "0100" => seg_RL <= "1001100";
						WHEN "0101" => seg_RL <= "0100100";
						WHEN "0110" => seg_RL <= "0100000";
						WHEN "0111" => seg_RL <= "0001111";
						WHEN "1000" => seg_RL <= "0000000";
						WHEN "1001" => seg_RL <= "0001100";
						WHEN "1010" => seg_RL <= "0001000";
						WHEN "1011" => seg_RL <= "1100000";
						WHEN "1100" => seg_RL <= "1110010";
						WHEN "1101" => seg_RL <= "1000010";
						WHEN "1110" => seg_RL <= "0110000";
						WHEN "1111" => seg_RL <= "0111000";
						WHEN others => seg_RL <= "1111111";
					end CASE;
					
					
					y <= S4;
			END CASE;
		END IF;	  
	END PROCESS;
	seven_count : hex PORT MAP(Count(3), Count(2), Count(1), Count(0), seg_count(0), seg_count(1), seg_count(2), seg_count(3), seg_count(4), seg_count(5), seg_count(6));
	WITH y SELECT
		 seg_step <= 
			  "0000001" WHEN Start,
			  "1001111" WHEN S1,
			  "0010010" WHEN S2a,
			  "0000110" WHEN S2b,
			  "1001100" WHEN S3,
			  "0100100" WHEN S4,
			  "1111111" WHEN others;


END LogicFunc;