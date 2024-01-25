LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY mux2to1 IS
    PORT (
        A, B, op : IN STD_LOGIC;
        Y : OUT STD_LOGIC);
END mux2to1;

ARCHITECTURE LogicFunc OF mux2to1 IS
BEGIN
    WITH op SELECT
        Y <= A WHEN '0',
             B WHEN '1';
END LogicFunc;