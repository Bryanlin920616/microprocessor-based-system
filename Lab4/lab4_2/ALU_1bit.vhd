-- ALU_1bit.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.lab4_2package.all;

ENTITY ALU_1bit IS
	PORT( A, B, less, carryin : IN STD_LOGIC;
			opcode : IN STD_LOGIC_VECTOR(3 downto 0);
			result, set, carryout : OUT STD_LOGIC);
END ALU_1bit;

ARCHITECTURE LogicFunc OF ALU_1bit IS
	SIGNAL Amux_out, Bmux_out : STD_LOGIC;
	SIGNAL op_in : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL temp : STD_LOGIC_VECTOR(1 downto 0); 
	
BEGIN
	Amux : mux2to1 PORT MAP(A, not A, opcode(3),Amux_out);
	Bmux : mux2to1 PORT MAP(B, not B, opcode(2),Bmux_out);
	op_in(0) <= Amux_out and Bmux_out;
	op_in(1) <= Amux_out or Bmux_out;
	--cin must be opcode(2) to do the 2's complement
	adder : fullAdder port map(carryin, Amux_out, Bmux_out, op_in(2), carryout);
	op_in(3) <= less;
	
	-- combine three 2to1 into a 4to1 mux below	
	mux1 : mux2to1 PORT MAP(op_in(0), op_in(1), opcode(0), temp(0));
	mux2 : mux2to1 PORT MAP(op_in(2), op_in(3), opcode(0), temp(1));
	mux3 : mux2to1 PORT MAP(temp(0), temp(1), opcode(1), result);
	set <= less; -- slt do like this??

END LogicFunc;