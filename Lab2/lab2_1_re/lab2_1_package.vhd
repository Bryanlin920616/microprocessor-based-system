--lab2_1package.vhd
library ieee;
USE ieee.std_logic_1164.all;
package lab2_1_package is
	component fullAdder
		port ( Cin, x, y : in std_logic;
				 s, Cout : out std_logic);
	end component fullAdder;
	
	component hex
		port ( w, x, y, z : in std_logic;
				 a, b, c, d, e, f, g : out std_logic);
	end component hex;
end lab2_1_package;