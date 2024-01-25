library ieee;
USE ieee.std_logic_1164.all;
package fullAdder_1bit is
	component fullAdder
		port ( Cin, x, y : in std_logic;
				 s, Cout : out std_logic);
	end component fullAdder;
end fullAdder_1bit;