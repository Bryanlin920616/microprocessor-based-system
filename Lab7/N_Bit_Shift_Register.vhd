LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY N_Bit_Shift_Register IS
GENERIC (N : INTEGER := 8);
PORT(		clk 		: IN STD_LOGIC;
			clear		: IN STD_LOGIC;
			load		: IN STD_LOGIC;
			lr_sel	: IN STD_LOGIC;
			di			: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			sdi		: IN STD_LOGIC;
			qo			: BUFFER STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END;

ARCHITECTURE func OF N_Bit_Shift_Register IS
BEGIN
	PROCESS
	BEGIN
		WAIT UNTIL clk'event AND clk = '1';
		G1: FOR i IN N-1 DOWNTO 0 LOOP
			IF clear = '1' THEN
				qo(i) <= '0';
			ELSIF load = '1' THEN
				qo(i) <= di(i);
			ELSE --SHIFT
				IF lr_sel = '1' THEN--LEFT
					IF i = 0 THEN
						qo(i) <= sdi;
					ELSE
						qo(i) <= qo(i-1);
					END IF;
				ELSE				 --RIGHT
					IF i = N-1 THEN
						qo(i) <= sdi;
					ELSE
						qo(i) <= qo(i+1);
					END IF;
				END IF;
			END IF;
		END LOOP;
	END PROCESS;
END func;