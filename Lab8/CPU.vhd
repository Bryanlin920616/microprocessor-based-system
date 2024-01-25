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
			seg_Rt1, seg_Rt0, seg_Rs1, seg_Rs0 : OUT STD_LOGIC_VECTOR(0 TO 6);
			seg_busH, seg_busL : OUT STD_LOGIC_VECTOR(0 TO 6)
		);
END CPU;

ARCHITECTURE logicFunc OF CPU IS
	COMPONENT hex IS
		PORT (
			data : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			seg : OUT STD_LOGIC_VECTOR(0 TO 6));
	END COMPONENT;
	-- ASSIGN SIGNAL
	
	TYPE Reg_type IS (r0, r1, r2, r3);
	SIGNAL rs_type, rt_type : Reg_type;
--	SIGNAL RsOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
--	SIGNAL RtOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
--	SIGNAL Op : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Reg0, Reg1, Reg2, Reg3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Rs, Rt: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL temp_rst : STD_LOGIC_VECTOR(7 DOWNTO 0);
		  
	
BEGIN

	PROCESS(clk, Op, RsOp, RtOp)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF RsOp = "00" THEN
				 rs_type <= r0;
				 Rs <= Reg0;
			ELSIF RsOp = "01" THEN
				 rs_type <= r1;
				 Rs <= Reg1;
			ELSIF RsOp = "10" THEN
				 rs_type <= r2;
				 Rs <= Reg2;
			ELSIF RsOp = "11" THEN
				 rs_type <= r3;
				 Rs <= Reg3;
			ELSE
				 -- Handle the case when RsOp is not matched
			END IF;

			IF RtOp = "00" THEN
				 rt_type <= r0;
				 Rt <= Reg0;
			ELSIF RtOp = "01" THEN
				 rt_type <= r1;
				 Rt <= Reg1;
			ELSIF RtOp = "10" THEN
				 rt_type <= r2;
				 Rt <= Reg2;
			ELSIF RtOp = "11" THEN
				 rt_type <= r3;
				 Rt <= Reg3;
			ELSE
				 -- Handle the case when RtOp is not matched
			END IF;

					
			CASE Op IS
				WHEN "0000" =>

					IF RsOp = "00" THEN
						Reg0 <= data;
					ELSIF RsOp = "01" THEN
						Reg1 <= data;
					ELSIF RsOp = "10" THEN
						Reg2 <= data;
					ELSE
						Reg3 <= data;
					END IF;
					
				WHEN "0001" =>
					Rs <= Rt;
					IF rs_type = r0 THEN
						Reg0 <= Rs;
					ELSIF rs_type = r1 THEN
						Reg1 <= Rs;
					ELSIF rs_type = r2 THEN
						Reg2 <= Rs;
					ELSIF rs_type = r3 THEN
						Reg3 <= Rs;
					END IF;
				WHEN "0010" =>
					Rs <= Rs + Rt;
					IF rs_type = r0 THEN
						Reg0 <= Rs;
					ELSIF rs_type = r1 THEN
						Reg1 <= Rs;
					ELSIF rs_type = r2 THEN
						Reg2 <= Rs;
					ELSIF rs_type = r3 THEN
						Reg3 <= Rs;
					END IF;
				WHEN "0011" =>
					Rs <= Rs AND Rt;
					IF rs_type = r0 THEN
						Reg0 <= Rs;
					ELSIF rs_type = r1 THEN
						Reg1 <= Rs;
					ELSIF rs_type = r2 THEN
						Reg2 <= Rs;
					ELSIF rs_type = r3 THEN
						Reg3 <= Rs;
					END IF;
				WHEN "0101" =>
					Rs <= Rs - Rt;
					IF rs_type = r0 THEN
						Reg0 <= Rs;
					ELSIF rs_type = r1 THEN
						Reg1 <= Rs;
					ELSIF rs_type = r2 THEN
						Reg2 <= Rs;
					ELSIF rs_type = r3 THEN
						Reg3 <= Rs;
					END IF;
				WHEN "1001" =>
					Rs <= Rt - Rs;
					IF rs_type = r0 THEN
						Reg0 <= Rs;
					ELSIF rs_type = r1 THEN
						Reg1 <= Rs;
					ELSIF rs_type = r2 THEN
						Reg2 <= Rs;
					ELSIF rs_type = r3 THEN
						Reg3 <= Rs;
					END IF;
				WHEN "0100" =>
					-- USE '<', SHOULD BE CHECK THAT THERE'S NO EXCEPTION
					If Rs < Rt THEN
						Rs <= "00000001";
					ELSE
						Rs <= "00000000";
					END IF;
					IF rs_type = r0 THEN
						Reg0 <= Rs;
					ELSIF rs_type = r1 THEN
						Reg1 <= Rs;
					ELSIF rs_type = r2 THEN
						Reg2 <= Rs;
					ELSIF rs_type = r3 THEN
						Reg3 <= Rs;
					END IF;
				WHEN OTHERS =>
			END CASE;
			IF RtOp = "00" THEN
				 rt_type <= r0;
				 Rt <= Reg0;
			ELSIF RtOp = "01" THEN
				 rt_type <= r1;
				 Rt <= Reg1;
			ELSIF RtOp = "10" THEN
				 rt_type <= r2;
				 Rt <= Reg2;
			ELSIF RtOp = "11" THEN
				 rt_type <= r3;
				 Rt <= Reg3;
			ELSE
				 -- Handle the case when RtOp is not matched
			END IF;
		END IF;
	
		
		
	
	END PROCESS;
	
	
	seven_busH : hex PORT MAP(Data(7 DOWNTO 4), seg_busH(0 TO 6));
	seven_busL : hex PORT MAP(Data(3 DOWNTO 0), seg_busL(0 TO 6));
	seven_Rt1 : hex PORT MAP(Rt(7 DOWNTO 4), seg_Rt1(0 TO 6));
	seven_Rt0 : hex PORT MAP(Rt(3 DOWNTO 0), seg_Rt0(0 TO 6));
	seven_Rs1 : hex PORT MAP(Rs(7 DOWNTO 4), seg_Rs1(0 TO 6));
	seven_Rs0 : hex PORT MAP(Rs(3 DOWNTO 0), seg_Rs0(0 TO 6));
	
END logicFunc;