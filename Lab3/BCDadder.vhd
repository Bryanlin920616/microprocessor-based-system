--BCDadder.vhd
library ieee;
use ieee.std_logic_1164.all;
use work.lab3_package.all;

entity BCDadder is
	port( A, B : in std_logic_vector(7 downto 0);
			hex1, hex2 : out std_logic_vector(6 downto 0);
			led : out std_logic);
end BCDadder;

architecture func of BCDadder is
	SIGNAL S : STD_LOGIC_VECTOR(7 downto 0);
begin
-- c0 didn't be assigned
	BCD0 : BCD PORT MAP(A, B, S, led);

	seven0 : hex PORT MAP(S(3), S(2), S(1), S(0), hex1(6), hex1(5), hex1(4), hex1(3), hex1(2), hex1(1), hex1(0));
	seven1 : hex PORT MAP(S(7), S(6), S(5), S(4), hex2(6), hex2(5), hex2(4), hex2(3), hex2(2), hex2(1), hex2(0));
	
	
end func;