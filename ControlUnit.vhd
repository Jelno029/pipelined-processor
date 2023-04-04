library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
port(
	op: in std_logic_vector(5 downto 0);
	RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch: out std_logic;
	ALUOp	: out std_logic_vector(1 downto 0)
);
end ControlUnit;

architecture rtl of ControlUnit is

signal int_op: std_logic_vector(5 downto 0);
signal rformat, lw, sw, beq : std_logic;

begin 

	int_op <= op;
	
	rformat <= (not(int_op(5)) and not(int_op(4)) and not(int_op(3)) and not(int_op(2)) and not(int_op(1)) and not(int_op(0)));
	lw <= (int_op(5) and not(int_op(4)) and not(int_op(3)) and not(int_op(2)) and int_op(1) and int_op(0));
	sw <= (int_op(5) and not(int_op(4)) and int_op(3) and not(int_op(2)) and int_op(1) and int_op(0));
	beq <= (not(int_op(5)) and not(int_op(4)) and not(int_op(3)) and int_op(2) and not(int_op(1)) and not(int_op(0)));
	
	RegDst <= rformat;
	ALUSrc <= lw or sw;
	MemtoReg <= lw;
	RegWrite <= rformat or lw;
	MemRead <= lw;
	MemWrite <= sw;
	Branch <= beq;
	ALUOp(1) <= rformat;
	ALUOp(0) <= beq; 
end rtl;
