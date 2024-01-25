library ieee;
use ieee.std_logic_1164.all;

entity fullAdder is
	port( Cin, x, y : in std_logic;
			s, cout : out std_logic);
end fullAdder;

architecture func of fullAdder is
begin
	s <= x xor y xor Cin;
	cout <= (x and y) or (Cin and x) or (Cin and y);
end func;