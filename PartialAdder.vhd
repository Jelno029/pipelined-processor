library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity PartialAdder is
port(
	A, B, Cin: in std_logic;
	S, P, G: out std_logic
	);
end PartialAdder;

architecture struct of PartialAdder is
begin
	S <= A xor B xor Cin;
	P <= A or B;
	G <= A and B;
end struct;