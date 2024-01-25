-- lab3_package.vhd
library ieee;
USE ieee.std_logic_1164.all;
package lab3_package is
	component fullAdder
		port ( Cin, x, y : in std_logic;
				 s, Cout : out std_logic);
	end component fullAdder;

	component hex
		port ( w, x, y, z : in std_logic;
				 a, b, c, d, e, f, g : out std_logic);
	end component hex;
	
	component BCD
		port ( A, B : in std_logic_vector(7 downto 0);
				 S : out std_logic_vector(7 downto 0);
				 Cout : out std_logic);
	end component BCD;
end lab3_package;