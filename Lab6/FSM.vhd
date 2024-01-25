LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY FSM IS
    PORT(
        clk, reset, w : IN STD_LOGIC;
        output : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE logicFun OF FSM IS
    TYPE state_type IS (Start, S1, S2a, S2b, S3, S4);
	 SIGNAL y : state_type;
BEGIN
    PROCESS(reset, clk)
    BEGIN
			IF reset = '1' THEN
				y <= Start;
			ELSIF clk'EVENT AND clk = '1' THEN
				CASE y IS
					-- Add your case statements here
					WHEN Start =>
						IF w = '1' THEN
							y <= S1;
	--					ELSE
	--						y <= Start;
						END IF;
						
					WHEN S1 =>
						IF w = '0' THEN
							y <= S2a;
						ELSE
							y <= S2b;
						END IF;
						
					WHEN S2a =>
						y <= S3;
					WHEN S2b =>
						y <= S3;
						
					WHEN S3 =>
						IF w = '0' THEN
							y <= S1;
						ELSE
							y <= S4;
						END IF;
					WHEN S4 =>
						y <= S4;
			  END CASE;
		  END IF;
			  
--		  IF y = Start THEN
--				output <= "000";
--		  ELSIF y = S1 THEN
--				output <= "001";
--		  ELSIF y = S2a THEN
--				output <= "010";
--		  ELSIF y = S2b THEN
--				output <= "011";
--		  ELSIF y = S3 THEN
--				output <= "100";
--		  ELSIF y = S4 THEN
--				output <= "101";
		  END IF;
    END PROCESS;
	 output <= "000" when y = Start,
			"001" when y = S1,
			"010" when y = S2a,
			"011" when y = S2b,
			"100" when y = S3,
			"101" when y = S4,
			"000" when others; -- 預設值


END ARCHITECTURE;
