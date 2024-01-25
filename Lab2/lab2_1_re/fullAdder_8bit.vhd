-- fullAdder_8bit.vhd
library ieee;
use ieee.std_logic_1164.all;
use work.lab2_1_package.all;

entity fullAdder_8bit is
	port( X, Y : in std_logic_vector(7 downto 0);
			hex1, hex2 : out std_logic_vector(6 downto 0);
			overflow: out std_logic);
end fullAdder_8bit;

architecture func of fullAdder_8bit is
--	signal Cout : std_logic;
	signal C, S : std_logic_vector(7 downto 0);
begin
-- c0 didn't be assigned
	stage0: fullAdder port map(C(0), X(0), Y(0), S(0), C(1));
	stage1: fullAdder port map(C(1), X(1), Y(1), S(1), C(2));
	stage2: fullAdder port map(C(2), X(2), Y(2), S(2), C(3));
	stage3: fullAdder port map(C(3), X(3), Y(3), S(3), C(4));
	stage4: fullAdder port map(C(4), X(4), Y(4), S(4), C(5));
	stage5: fullAdder port map(C(5), X(5), Y(5), S(5), C(6));
	stage6: fullAdder port map(C(6), X(6), Y(6), S(6), C(7));
	stage7: fullAdder port map(C(7), X(7), Y(7), S(7), overflow);
	
	seven0 : hex PORT MAP(S(3), S(2), S(1), S(0), hex1(6), hex1(5), hex1(4), hex1(3), hex1(2), hex1(1), hex1(0));
	seven1 : hex PORT MAP(S(7), S(6), S(5), S(4), hex2(6), hex2(5), hex2(4), hex2(3), hex2(2), hex2(1), hex2(0));
	
end func;