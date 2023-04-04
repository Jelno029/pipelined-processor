library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUCtrlUnit is
port(
	i_F: in std_logic_vector(5 downto 0);
	i_ALUOp: in std_logic_vector(1 downto 0);
	o_op: out std_logic_vector(2 downto 0)
);
end ALUCtrlUnit;

architecture rtl of ALUCtrlUnit is

signal int_F: std_logic_vector(5 downto 0);
signal int_ALUOp: std_logic_vector(1 downto 0);
signal int_opOut: std_logic_vector(2 downto 0);

begin 

	int_F <= i_F;
	int_ALUOp <= i_ALUOp;
	
	int_opOut(2) <= int_ALUOp(0) or (int_ALUOp(1) and int_F(1));
	int_opOut(1) <= not(int_ALUOp(1)) or not(int_F(2));
	int_opOut(0) <= int_ALUOp(1) and (int_F(3) or int_F(0));
	
	o_op <= int_opOut;
	
	
end rtl;
