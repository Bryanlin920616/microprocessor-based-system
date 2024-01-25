Library ieee;
USE ieee.std_logic_1164.all;
ENTITY hex IS
	PORT (
		data : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		seg : OUT STD_LOGIC_VECTOR(0 TO 6));
END hex;

ARCHITECTURE LogicFunc OF hex IS
BEGIN	
	seg <="0000001" when data = "0000" else
			"1001111" when data = "0001" else
			"0010010" when data = "0010" else
			"0000110" when data = "0011" else
			"1001100" when data = "0100" else
			"0100100" when data = "0101" else
			"0100000" when data = "0110" else
			"0001111" when data = "0111" else
			"0000000" when data = "1000" else
			"0001100" when data = "1001" else
			"0001000" when data = "1010" else
			"1100000" when data = "1011" else
			"1110010" when data = "1100" else
			"1000010" when data = "1101" else
			"0110000" when data = "1110" else
			"0111000" when data = "1111" else
			"1111111";

END LogicFunc;