-- BCD.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.lab3_package.all;
ENTITY BCD IS
	 port ( A, B : in std_logic_vector(7 downto 0);
			  S : out std_logic_vector(7 downto 0);
			  Cout : out std_logic);
    END BCD;
ARCHITECTURE func OF BCD IS
	SIGNAL Cn : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL C, C1 : STD_LOGIC_VECTOR(8	downto 0);
	SIGNAL temp : STD_LOGIC_VECTOR(7	downto 0);
BEGIN
	stage0: fullAdder port map(C(0), A(0), B(0), temp(0), C(1));
	stage1: fullAdder port map(C(1), A(1), B(1), temp(1), C(2));
	stage2: fullAdder port map(C(2), A(2), B(2), temp(2), C(3));
	stage3: fullAdder port map(C(3), A(3), B(3), temp(3), C(4));
	
	Cn(0) <= C(4) or (temp(3) and temp(2)) or (temp(3) and temp(1));
	
	stage4: fullAdder port map('0', '0', temp(0), S(0), C(5));
	stage5: fullAdder port map(C(5), Cn(0), temp(1), S(1), C(6));
	stage6: fullAdder port map(C(6), Cn(0), temp(2), S(2), C(7));
	stage7: fullAdder port map(C(7), '0', temp(3), S(3), C(8));
--	=====================================
	stage8: fullAdder port map(Cn(0), A(4), B(4), temp(4), C1(1));
	stage9: fullAdder port map(C1(1), A(5), B(5), temp(5), C1(2));
	stage10: fullAdder port map(C1(2), A(6), B(6), temp(6), C1(3));
	stage11: fullAdder port map(C1(3), A(7), B(7), temp(7), C1(4));
	
	Cn(1) <= C1(4) or (temp(7) and temp(6)) or (temp(7) and temp(5));
	Cout <= Cn(1);
	
	stage12: fullAdder port map('0', '0', temp(4), S(4), C1(5));
	stage13: fullAdder port map(C1(5), Cn(1), temp(5), S(5), C1(6));
	stage14: fullAdder port map(C1(6), Cn(1), temp(6), S(6), C1(7));
	stage15: fullAdder port map(C1(7), '0', temp(7), S(7), C1(8));	
END func;