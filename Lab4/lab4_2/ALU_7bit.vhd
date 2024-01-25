-- ALU_7bit.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.lab4_2package.all;

ENTITY ALU_7bit IS
	PORT( A, B : IN STD_LOGIC_VECTOR(6 downto 0);
			opcode : IN STD_LOGIC_VECTOR(3 downto 0);
			hex1, hex0 : OUT STD_LOGIC_VECTOR(6 downto 0));
END ALU_7bit;

ARCHITECTURE LogicFunc OF ALU_7bit IS
	SIGNAL rst, set, Cout : STD_LOGIC_VECTOR(6 downto 0);
		
BEGIN
	G1: FOR i IN 0 TO 6 GENERATE
		G2: IF i /= 0 GENERATE
			ALU_mid : ALU_1bit PORT MAP(A(i), B(i), '0', Cout(i-1), opcode, rst(i), set(i), Cout(i));
		END GENERATE;
		G3: IF i = 0 GENERATE
			-- rst(6) to less0 to detect signed bit --rst(6)
			ALU_first : ALU_1bit PORT MAP(A(i), B(i), A(6) xor (not B(6)) xor Cout(5), opcode(2), opcode, rst(i), set(i), Cout(i));
		
		END GENERATE;
		
	END GENERATE;
	
	seven0 : hex PORT MAP(rst(3), rst(2), rst(1), rst(0), hex0(6), hex0(5), hex0(4), hex0(3), hex0(2), hex0(1), hex0(0));
	seven1 : hex PORT MAP('0', rst(6), rst(5), rst(4), hex1(6), hex1(5), hex1(4), hex1(3), hex1(2), hex1(1), hex1(0));
END LogicFunc;