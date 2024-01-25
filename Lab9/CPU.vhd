-- use four process to deal with each stage, parallel process
-- use shared variable signal to play the memory role
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CPU IS
	PORT( clk : IN STD_LOGIC;
			Data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Op : IN std_logic_vector(3 downto 0);
		   RsOp : IN std_logic_vector(1 downto 0);
		   RtOp : IN std_logic_vector(1 downto 0);
			-- Cycle : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			seg_Rt1, seg_Rt0, seg_Rs1, seg_Rs0 : OUT STD_LOGIC_VECTOR(0 TO 6);
			seg_busH, seg_busL : OUT STD_LOGIC_VECTOR(0 TO 6);
			seg_Rst1, seg_Rst0 : OUT STD_LOGIC_VECTOR(0 TO 6);
			hazardLED : OUT STD_LOGIC;
			showRegOp : IN std_logic_vector(1 downto 0)
		);
END CPU;
ARCHITECTURE logicFunc OF CPU IS
	COMPONENT hex IS
		PORT (
			data : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			seg : OUT STD_LOGIC_VECTOR(0 TO 6));
	END COMPONENT;
	
	SIGNAL Reg0, Reg1, Reg2, Reg3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL temp : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Count : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SHARED VARIABLE pipelineReg1: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00001111"; --RtOp(2)RsOp(2)OP(4)
	SHARED VARIABLE pipelineReg2: STD_LOGIC_VECTOR(23 DOWNTO 0) := "000011110000000000000000"; --RtOp(2)RsOp(2)OP(4)Rt(8)Rs(8)
	SHARED VARIABLE pipelineReg3: STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000"; --WE(1)RsOp(2)Result(8)
	SHARED VARIABLE pipe_data1, pipe_data2, pipe_data3: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SHARED VARIABLE TempRs, TempRt: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SHARED VARIABLE haz0, haz1 : STD_LOGIC := '0';
BEGIN
	-- instruction fetch(pass the RtOp(2)RsOp(2)OP(4) to pipeline1)
	PROCESS(clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			pipelineReg1 := RtOp & RsOp & OP;
			pipe_data1 := Data;
			
			-- COUNTER
			IF Count = "1111" THEN
				Count <= "0000";
			ELSE
				Count <= Count + "0001";
			END IF;
		END IF;
		

	END PROCESS;
	
	-- get info from pipeline1, then read data and put the data and Op, RsOp to pipeline2
	-- RtOp = pipelineReg1(7 DOWNTO 6)
	-- RsOp = pipelineReg1(5 DOWNTO 4)
	-- Op = pipelineReg1(3 DOWNTO 0)
	PROCESS(clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			CASE pipelineReg1(7 DOWNTO 6) is --read Rt
				WHEN "00" => 
					IF pipelineReg3(9 DOWNTO 8) = "00" THEN
						pipelineReg2(15 DOWNTO 8) := pipelineReg3(7 DOWNTO 0);
					ELSE
						pipelineReg2(15 DOWNTO 8) := Reg0;
					END IF;
				WHEN "01" => 
					IF pipelineReg3(9 DOWNTO 8) = "01" THEN
						pipelineReg2(15 DOWNTO 8) := pipelineReg3(7 DOWNTO 0);
					ELSE
						pipelineReg2(15 DOWNTO 8) := Reg1;
					END IF;
				WHEN "10" => 
					IF pipelineReg3(9 DOWNTO 8) = "10" THEN
						pipelineReg2(15 DOWNTO 8) := pipelineReg3(7 DOWNTO 0);
					ELSE
						pipelineReg2(15 DOWNTO 8) := Reg2;
					END IF;
				WHEN "11" => 
					IF pipelineReg3(9 DOWNTO 8) = "11" THEN
						pipelineReg2(15 DOWNTO 8) := pipelineReg3(7 DOWNTO 0);
					ELSE
						pipelineReg2(15 DOWNTO 8) := Reg3;
					END IF;
			END CASE;
			
			CASE pipelineReg1(5 DOWNTO 4) is --read Rs
				WHEN "00" => 
					IF pipelineReg3(9 DOWNTO 8) = "00" THEN
						pipelineReg2(7 DOWNTO 0) := pipelineReg3(7 DOWNTO 0);
					ELSE
						pipelineReg2(7 DOWNTO 0) := Reg0;
					END IF;
				WHEN "01" => 
					IF pipelineReg3(9 DOWNTO 8) = "01" THEN
						pipelineReg2(7 DOWNTO 0) := pipelineReg3(7 DOWNTO 0);
					ELSE
						pipelineReg2(7 DOWNTO 0) := Reg1;
					END IF;
				WHEN "10" => 
					IF pipelineReg3(9 DOWNTO 8) = "10" THEN
						pipelineReg2(7 DOWNTO 0) := pipelineReg3(7 DOWNTO 0);
					ELSE
						pipelineReg2(7 DOWNTO 0) := Reg2;
					END IF;
				WHEN "11" => 
					IF pipelineReg3(9 DOWNTO 8) = "11" THEN
						pipelineReg2(7 DOWNTO 0) := pipelineReg3(7 DOWNTO 0);
					ELSE
						pipelineReg2(7 DOWNTO 0) := Reg3;
					END IF;
			END CASE;
			
			pipelineReg2(23 DOWNTO 22) := pipelineReg1(7 DOWNTO 6); --RtOp
			pipelineReg2(21 DOWNTO 20) := pipelineReg1(5 DOWNTO 4); --RsOp
			pipelineReg2(19 DOWNTO 16) := pipelineReg1(3 DOWNTO 0); --Op
			pipe_data2 := pipe_data1;
		END IF;
	END PROCESS;
	
	-- get Rs, Rt, Op and compute the rst, then put RsOp and rst into pipeline3
	-- RtOp(2) = pipelineReg2(23 DOWNTO 22)
	-- RsOp(2) = pipelineReg2(21 DOWNTO 20)
	-- OP(4) = pipelineReg2(19 DOWNTO 16)
	-- Rt(8) = pipelineReg2(15 DOWNTO 8)
	-- Rs(8) = pipelineReg2(7 DOWNTO 0)
	PROCESS(clk)
--		variable dividend_unsigned, divisor_unsigned, quotient_unsigned, remainder_unsigned : unsigned(7 downto 0);
	BEGIN
		IF clk'event AND clk = '1' THEN
			
			IF (pipelineReg3(9 DOWNTO 8) = pipelineReg2(23 DOWNTO 22)) AND (pipelineReg3(10) = '1') THEN --Rt
				TempRt := pipelineReg3(7 DOWNTO 0); -- from pipelineReg3(write back)
			ELSE
				TempRt := pipelineReg2(15 DOWNTO 8);
			END IF;
			IF (pipelineReg3(9 DOWNTO 8) = pipelineReg2(21 DOWNTO 20)) AND (pipelineReg3(10) = '1') THEN --Rs
				TempRs := pipelineReg3(7 DOWNTO 0); -- from pipelineReg3(write back)
			ELSE
				TempRs := pipelineReg2(7 DOWNTO 0);
			END IF;
			
			CASE pipelineReg2(19 DOWNTO 16) IS --Op
				WHEN "0000" =>
					pipelineReg3(7 DOWNTO 0) := pipe_data2;
					pipelineReg3(10) := '1';
				WHEN "0001" =>
					pipelineReg3(7 DOWNTO 0) := TempRt;
					pipelineReg3(10) := '1';
				WHEN "0010" =>
					pipelineReg3(7 DOWNTO 0) := TempRs + TempRt;
					pipelineReg3(10) := '1';
				WHEN "0011" =>
					pipelineReg3(7 DOWNTO 0) := TempRs - TempRt;
					pipelineReg3(10) := '1';
				WHEN "0100" =>
					pipelineReg3(7 DOWNTO 0) := TempRt AND TempRs;
					pipelineReg3(10) := '1';
				WHEN "0101" =>
					pipelineReg3(7 DOWNTO 0) := TempRt OR TempRs;
					pipelineReg3(10) := '1';
				WHEN "0110" =>
					pipelineReg3(7 DOWNTO 0) := TempRt NOR TempRs;
					pipelineReg3(10) := '1';
				WHEN "0111" =>
					-- USE '<', SHOULD BE CHECK THAT THERE'S NO EXCEPTION
					IF TempRs < TempRt THEN
						pipelineReg3(7 DOWNTO 0) := "00000001";
					ELSE
						pipelineReg3(7 DOWNTO 0) := "00000000";
					END IF;
					pipelineReg3(10) := '1';
				WHEN "1000" => --DIV
					pipelineReg3(7 DOWNTO 0) := STD_LOGIC_VECTOR(unsigned(TempRs) / unsigned(TempRt));
					pipelineReg3(10) := '1';
				WHEN "1111" => --NO INSTRUCTION
					pipelineReg3(10) := '0';
				WHEN OTHERS =>
					pipelineReg3(10) := '0';
					
			END CASE;
			pipelineReg3(9 DOWNTO 8) := pipelineReg2(21 DOWNTO 20); --RsOp
			
			CASE pipelineReg3(7 DOWNTO 4) IS
				WHEN "0000" => seg_Rs1 <= "0000001";
				WHEN "0001" => seg_Rs1 <= "1001111";
				WHEN "0010" => seg_Rs1 <= "0010010";
				WHEN "0011" => seg_Rs1 <= "0000110";
				WHEN "0100" => seg_Rs1 <= "1001100";
				WHEN "0101" => seg_Rs1 <= "0100100";
				WHEN "0110" => seg_Rs1 <= "0100000";
				WHEN "0111" => seg_Rs1 <= "0001111";
				WHEN "1000" => seg_Rs1 <= "0000000";
				WHEN "1001" => seg_Rs1 <= "0001100";
				WHEN "1010" => seg_Rs1 <= "0001000";
				WHEN "1011" => seg_Rs1 <= "1100000";
				WHEN "1100" => seg_Rs1 <= "1110010";
				WHEN "1101" => seg_Rs1 <= "1000010";
				WHEN "1110" => seg_Rs1 <= "0110000";
				WHEN "1111" => seg_Rs1 <= "0111000";
				WHEN OTHERS => seg_Rs1 <= "1111111";
			END CASE;

			CASE pipelineReg3(3 DOWNTO 0) IS
				WHEN "0000" => seg_Rs0 <= "0000001";
				WHEN "0001" => seg_Rs0 <= "1001111";
				WHEN "0010" => seg_Rs0 <= "0010010";
				WHEN "0011" => seg_Rs0 <= "0000110";
				WHEN "0100" => seg_Rs0 <= "1001100";
				WHEN "0101" => seg_Rs0 <= "0100100";
				WHEN "0110" => seg_Rs0 <= "0100000";
				WHEN "0111" => seg_Rs0 <= "0001111";
				WHEN "1000" => seg_Rs0 <= "0000000";
				WHEN "1001" => seg_Rs0 <= "0001100";
				WHEN "1010" => seg_Rs0 <= "0001000";
				WHEN "1011" => seg_Rs0 <= "1100000";
				WHEN "1100" => seg_Rs0 <= "1110010";
				WHEN "1101" => seg_Rs0 <= "1000010";
				WHEN "1110" => seg_Rs0 <= "0110000";
				WHEN "1111" => seg_Rs0 <= "0111000";
				WHEN OTHERS => seg_Rs0 <= "1111111";
			END CASE;
			
			CASE TempRt(7 DOWNTO 4) IS
				WHEN "0000" => seg_Rt1 <= "0000001";
				WHEN "0001" => seg_Rt1 <= "1001111";
				WHEN "0010" => seg_Rt1 <= "0010010";
				WHEN "0011" => seg_Rt1 <= "0000110";
				WHEN "0100" => seg_Rt1 <= "1001100";
				WHEN "0101" => seg_Rt1 <= "0100100";
				WHEN "0110" => seg_Rt1 <= "0100000";
				WHEN "0111" => seg_Rt1 <= "0001111";
				WHEN "1000" => seg_Rt1 <= "0000000";
				WHEN "1001" => seg_Rt1 <= "0001100";
				WHEN "1010" => seg_Rt1 <= "0001000";
				WHEN "1011" => seg_Rt1 <= "1100000";
				WHEN "1100" => seg_Rt1 <= "1110010";
				WHEN "1101" => seg_Rt1 <= "1000010";
				WHEN "1110" => seg_Rt1 <= "0110000";
				WHEN "1111" => seg_Rt1 <= "0111000";
				WHEN OTHERS => seg_Rt1 <= "1111111";
			END CASE;

			CASE TempRt(3 DOWNTO 0) IS
				WHEN "0000" => seg_Rt0 <= "0000001";
				WHEN "0001" => seg_Rt0 <= "1001111";
				WHEN "0010" => seg_Rt0 <= "0010010";
				WHEN "0011" => seg_Rt0 <= "0000110";
				WHEN "0100" => seg_Rt0 <= "1001100";
				WHEN "0101" => seg_Rt0 <= "0100100";
				WHEN "0110" => seg_Rt0 <= "0100000";
				WHEN "0111" => seg_Rt0 <= "0001111";
				WHEN "1000" => seg_Rt0 <= "0000000";
				WHEN "1001" => seg_Rt0 <= "0001100";
				WHEN "1010" => seg_Rt0 <= "0001000";
				WHEN "1011" => seg_Rt0 <= "1100000";
				WHEN "1100" => seg_Rt0 <= "1110010";
				WHEN "1101" => seg_Rt0 <= "1000010";
				WHEN "1110" => seg_Rt0 <= "0110000";
				WHEN "1111" => seg_Rt0 <= "0111000";
				WHEN OTHERS => seg_Rt0 <= "1111111";
			END CASE;
	END IF;
	-- get rst&RsOp and write the rst in the Rs
	-- WriteEnable = pipelineReg3(10)
	-- RsOp(2) = pipelineReg3(9 DOWNTO 8)
	-- Result(8) = pipelineReg3(7 DOWNTO 0)
	END PROCESS;
	
	PROCESS(clk, Op, RsOp, RtOp)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF pipelineReg3(10) = '1' THEN
				IF (pipelineReg3(9 DOWNTO 8) = pipelineReg2(23 DOWNTO 22)) OR (pipelineReg3(9 DOWNTO 8) = pipelineReg2(21 DOWNTO 20)) THEN
					haz0 := '1';
				ELSE
					haz0 := '0';
				END IF;
				CASE pipelineReg3(9 DOWNTO 8) IS
					WHEN "00" => Reg0 <= pipelineReg3(7 DOWNTO 0);
					WHEN "01" => Reg1 <= pipelineReg3(7 DOWNTO 0);
					WHEN "10" => Reg2 <= pipelineReg3(7 DOWNTO 0);
					WHEN "11" => Reg3 <= pipelineReg3(7 DOWNTO 0);
				END CASE;
			ELSE
				haz0 := '0';
			END IF;
		END IF;
	
	END PROCESS;
	hazardLED <= haz0;
	seven_busH : hex PORT MAP(Data(7 DOWNTO 4), seg_busH(0 TO 6));
	seven_busL : hex PORT MAP(Data(3 DOWNTO 0), seg_busL(0 TO 6));
--	seven_Rt1 : hex PORT MAP(pipelineReg2(15 DOWNTO 12), seg_Rt1(0 TO 6));
--	seven_Rt0 : hex PORT MAP(pipelineReg2(11 DOWNTO 8), seg_Rt0(0 TO 6));
--	seven_Rs1 : hex PORT MAP(pipelineReg2(7 DOWNTO 4), seg_Rs1(0 TO 6));
--	seven_Rs0 : hex PORT MAP(pipelineReg2(3 DOWNTO 0), seg_Rs0(0 TO 6));
	temp <= Reg0 when showRegOp = "00" else
			Reg1 when showRegOp = "01" else
			Reg2 when showRegOp = "10" else
			Reg3 when showRegOp = "11";
			
	seven_Reg1 : hex PORT MAP(Count, seg_Rst1(0 TO 6)); --left 1	
--	seven_Reg1 : hex PORT MAP(temp(7 DOWNTO 4), seg_Rst1(0 TO 6)); --left 1
	seven_Reg0 : hex PORT MAP(temp(3 DOWNTO 0), seg_Rst0(0 TO 6)); --left 2 is current value

	-- show the rst of ALU stage
--	seven_Rst1 : hex PORT MAP(pipelineReg3(7 DOWNTO 4), seg_Rst1(0 TO 6));
--	seven_Rst0 : hex PORT MAP(pipelineReg3(3 DOWNTO 0), seg_Rst0(0 TO 6));

END logicFunc;