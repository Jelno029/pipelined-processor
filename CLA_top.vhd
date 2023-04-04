library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity CLA_top is
port(
	A, B: in std_logic_vector(9 downto 0);
	Cin: in std_logic;
	S: out std_logic_vector(9 downto 0);
	Cout: out std_logic);
end CLA_top;

architecture struct of CLA_top is
	component PartialAdder 
	port(
		A, B, Cin: in std_logic;
		S, P, G: out std_logic
		);
	end component;
	
	signal int_A, int_B: std_logic_vector(9 downto 0);
	signal c1, c2, c3, c4, c5, c6, c7, c8, c9: std_logic;
	signal G, P: std_logic_vector(9 downto 0);
	
	begin
	
		int_A <= A;
		int_B <= B;
		
		PA0: PartialAdder
		port map(
			A => int_A(0), 
			B => int_B(0), 
			Cin => Cin,
			S => S(0), 
			P => P(0), 
			G => G(0)
		);
		
		PA1: PartialAdder
		port map(
			A => int_A(1), 
			B => int_B(1), 
			Cin => c1,
			S => S(1), 
			P => P(1), 
			G => G(1)
		);
		
		PA2: PartialAdder
		port map(
			A => int_A(2), 
			B => int_B(2), 
			Cin => c2,
			S => S(2), 
			P => P(2), 
			G => G(2)
		);
	
		PA3: PartialAdder
		port map(
			A => int_A(3), 
			B => int_B(3), 
			Cin => c3,
			S => S(3), 
			P => P(3), 
			G => G(3)
		);
		
		PA4: PartialAdder
		port map(
			A => int_A(4), 
			B => int_B(4), 
			Cin => c4,
			S => S(4), 
			P => P(4), 
			G => G(4)
		);
		
		PA5: PartialAdder
		port map(
			A => int_A(5), 
			B => int_B(5), 
			Cin => c5,
			S => S(5), 
			P => P(5), 
			G => G(5)
		);
		
		PA6: PartialAdder
		port map(
			A => int_A(6), 
			B => int_B(6), 
			Cin => c6,
			S => S(6), 
			P => P(6), 
			G => G(6)
		);
		
		PA7: PartialAdder
		port map(
			A => int_A(7), 
			B => int_B(7), 
			Cin => c7,
			S => S(7), 
			P => P(7), 
			G => G(7)
		);
		
		PA8: PartialAdder
		port map(
			A => int_A(8), 
			B => int_B(8), 
			Cin => c8,
			S => S(8), 
			P => P(8), 
			G => G(8)
		);
		
		PA9: PartialAdder
		port map(
			A => int_A(9), 
			B => int_B(9), 
			Cin => c9,
			S => S(9), 
			P => P(9), 
			G => G(9)
		);
		
	c1 <= G(0) or (P(0) and Cin);
	c2 <= G(1) or (P(1) and c1);
	c3 <= G(2) or (P(2) and c2);
	c4 <= G(3) or (P(3) and c3);
	c5 <= G(4) or (P(4) and c4);
	c6 <= G(5) or (P(5) and c5);
	c7 <= G(6) or (P(6) and c6);
	c8 <= G(7) or (P(7) and c7);
	c9 <= G(8) or (P(8) and c8);
	
	Cout <= G(9) or (P(9) and c9);
	
end struct;