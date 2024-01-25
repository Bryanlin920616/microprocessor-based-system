library ieee;
USE ieee.std_logic_1164.all;
package lab4_package is
	component fullAdder
		port ( Cin, x, y : in std_logic;
				 s, Cout : out std_logic);
	end component fullAdder;

	component mux2to1
    port (
        A, B, op : IN STD_LOGIC;
        Y : OUT STD_LOGIC);
	end component mux2to1;
	
	component hex
		port ( w, x, y, z : in std_logic;
				 a, b, c, d, e, f, g : out std_logic);
	end component hex;

end lab4_package;