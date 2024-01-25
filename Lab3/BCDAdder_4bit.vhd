LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all ;
USE work.fullAdder_1bit.all ;
ENTITY BCDAdder_4bit IS
    PORT(
        A, B : IN STD_LOGIC_VECTOR(3 downto 0);
        S : OUT STD_LOGIC_VECTOR(3 downto 0);
        Cout : OUT STD_LOGIC);
    END BCDAdder_4bit;
ARCHITECTURE func OF BCDAdder_4bit IS
	SIGNAL temp : STD_LOGIC_VECTOR(4	downto 0);
	
BEGIN
END func;