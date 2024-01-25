library ieee;
use ieee.std_logic_1164.all;
use work.fullAdder_1bit.all;

entity fullAdder_4bit is
	port( X, Y : in std_logic_vector(3 downto 0);
			S : out std_logic(3 downto 0);
			Cin : in std_logic;
			Cout : out std_logic);
end fullAdder_4bit;

architecture func of fullAdder_4bit is
	signal C: std_logic_vector(3 downto 0);
begin
-- c0 didn't be assigned
	stage0: fullAdder port map(Cin, X(0), Y(0), S(0), C(1));
	stage1: fullAdder port map(C(1), X(1), Y(1), S(1), C(2));
	stage2: fullAdder port map(C(2), X(2), Y(2), S(2), C(3));
	stage3: fullAdder port map(C(3), X(3), Y(3), S(3), Cout);
	
	
end func;