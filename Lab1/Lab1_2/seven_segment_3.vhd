Library ieee; --seven_segment_3.vhd
USE ieee.std_logic_1164.all;
ENTITY seven_segment_3 IS
	PORT (
		w, x, y, z : IN STD_LOGIC;
		a, b, c, d, e, f, g : OUT STD_LOGIC;
		
		w1, x1, y1, z1 : IN STD_LOGIC;
		a1, b1, c1, d1, e1, f1, g1 : OUT STD_LOGIC;
		
		w2, x2, y2, z2 : IN STD_LOGIC;
		a2, b2, c2, d2, e2, f2, g2 : OUT STD_LOGIC
		);
END seven_segment_3;

ARCHITECTURE LogicFunc OF seven_segment_3 IS
BEGIN
	a <= (not w and not x and not y and z) or (x and not y and not z) or (w and not x and y and z) or (w and x and not y);
	b <= (not w and x and not y and z) or (x and y and not z) or (w and y and z) or (w and x and not z);
	c <= (not w and not x and y and not z) or (w and x and not z) or (w and x and y);
	d <= (not x and not y and z) or (not w and x and not y and not z) or (x and y and z) or (w and not x and y and not z);
	e <= (not w and z) or (not w and x and not y) or (not x and not y and z);
	f <= (not w and not x and z) or (not w and not x and y) or (not w and y and z) or (w and x and not y);
	g <= (not w and not x and not y) or (not w and x and y and z);
	
	a1 <= (not w1 and not x1 and not y1 and z1) or (x1 and not y1 and not z1) or (w1 and not x1 and y1 and z1) or (w1 and x1 and not y1);
	b1 <= (not w1 and x1 and not y1 and z1) or (x1 and y1 and not z1) or (w1 and y1 and z1) or (w1 and x1 and not z1);
	c1 <= (not w1 and not x1 and y1 and not z1) or (w1 and x1 and not z1) or (w1 and x1 and y1);
	d1 <= (not x1 and not y1 and z1) or (not w1 and x1 and not y1 and not z1) or (x1 and y1 and z1) or (w1 and not x1 and y1 and not z1);
	e1 <= (not w1 and z1) or (not w1 and x1 and not y1) or (not x1 and not y1 and z1);
	f1 <= (not w1 and not x1 and z1) or (not w1 and not x1 and y1) or (not w1 and y1 and z1) or (w1 and x1 and not y1);
	g1 <= (not w1 and not x1 and not y1) or (not w1 and x1 and y1 and z1);
	
	a2 <= (not w2 and not x2 and not y2 and z2) or (x2 and not y2 and not z2) or (w2 and not x2 and y2 and z2) or (w2 and x2 and not y2);
	b2 <= (not w2 and x2 and not y2 and z2) or (x2 and y2 and not z2) or (w2 and y2 and z2) or (w2 and x2 and not z2);
	c2 <= (not w2 and not x2 and y2 and not z2) or (w2 and x2 and not z2) or (w2 and x2 and y2);
	d2 <= (not x2 and not y2 and z2) or (not w2 and x2 and not y2 and not z2) or (x2 and y2 and z2) or (w2 and not x2 and y2 and not z2);
	e2 <= (not w2 and z2) or (not w2 and x2 and not y2) or (not x2 and not y2 and z2);
	f2 <= (not w2 and not x2 and z2) or (not w2 and not x2 and y2) or (not w2 and y2 and z2) or (w2 and x2 and not y2);
	g2 <= (not w2 and not x2 and not y2) or (not w2 and x2 and y2 and z2);
END LogicFunc;