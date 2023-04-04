library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity subtop is
port(
		i_instruction	:	in std_logic_vector(31 downto 0);
		i_pcplus4		:  in std_logic_vector(9  downto 0);
		i_writeData		:	in std_logic_vector(7 downto 0);
		i_clk				:	in std_logic;
		
		o_branchMuxOut	: out std_logic_vector(9 downto 0);
		o_aluOut			: out std_logic_vector(7 downto 0);
		o_readData2		: out std_logic_vector(7 downto 0);
		o_memWrite		: out std_logic;
		o_memToReg		: out std_logic;
		o_memRead		: out std_logic);
end subtop;


architecture subtop_rtl of subtop is

component registerFile is
port(
		i_regWrite	:	in std_logic;
		i_readReg1	:	in std_logic_vector(2 downto 0);
		i_readReg2	:	in std_logic_vector(2 downto 0);
		i_writeReg	:	in std_logic_vector(2 downto 0);
		i_writeData	:	in std_logic_vector(7 downto 0);
		
		i_clk, i_clr	:	in std_logic;
		
		o_readData1	:	out std_logic_vector(7 downto 0);
		o_readData2	:	out std_logic_vector(7 downto 0));
end component;

component ControlUnit is
port(
		op		: in std_logic_vector(5 downto 0);
		RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch: out std_logic;
		ALUOp	: out std_logic_vector(1 downto 0));
end component;

component ALUCtrlUnit is
port(
		i_F		: in std_logic_vector(5 downto 0);
		i_ALUOp	: in std_logic_vector(1 downto 0);
		o_op		: out std_logic_vector(2 downto 0));
end component;

component mux2to1_8bit is
port(
		i_0, i_1	:	in std_logic_vector(7 downto 0);		-- 2 inputs, 8 bits
		i_select	:	in std_logic;								-- 1 selection bit
		o_output	:	out std_logic_vector(7 downto 0));	-- 1 output
end component;

component mux2to1_3bit is
port(
		i_0, i_1	:	in std_logic_vector(2 downto 0);		-- 2 inputs, 3 bits
		i_select	:	in std_logic;								-- 1 selection bit
		o_output	:	out std_logic_vector(2 downto 0));	-- 1 output
end component;

component mux2to1_10bit is
port(
		i_0, i_1	:	in std_logic_vector(9 downto 0);		-- 2 inputs, 10 bits
		i_select	:	in std_logic;								-- 1 selection bit
		o_output	:	out std_logic_vector(9 downto 0));	-- 1 output
end component;

component alu8bit is
port(
		i_op1, i_op2	: in std_logic_vector(7 downto 0);
		i_aluOp			: in std_logic_vector(2 downto 0);
		o_aluOut			: out std_logic_vector(7 downto 0));
end component;

component CLA_top is
port(
	A, B: in std_logic_vector(9 downto 0);
	Cin: in std_logic;
	S: out std_logic_vector(9 downto 0);
	Cout: out std_logic);
end component;


signal opcode	: std_logic_vector(5 downto 0);
signal inst23to21, inst18to16, inst13to11	: std_logic_vector(2 downto 0);
signal instSignReduce	: std_logic_vector(7 downto 0);
signal isrShifted			: std_logic_vector(9 downto 0);
signal readData1, readData2:	std_logic_vector(7 downto 0);
signal rfclr	: std_logic := '0';
signal aluzero				: std_logic := '0';
signal RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch: std_logic;
signal aluCtlin: std_logic_vector(1 downto 0);
signal aluCtlout: std_logic_vector(2 downto 0);
signal writeRegIn: std_logic_vector(2 downto 0);
signal aluSrcOut: std_logic_vector(7 downto 0);
signal aluOut: std_logic_vector(7 downto 0);
signal adderOut: std_logic_vector(9 downto 0);
signal branchAnd: std_logic;

begin

rfclr <= '1' after 1 ns;

--SPLIT the Instruction:
opcode		<= i_instruction(31 downto 26);
inst23to21 	<= i_instruction(23 downto 21);
inst18to16 	<= i_instruction(18 downto 16);
inst13to11 	<= i_instruction(13 downto 11);

instSignReduce <= i_instruction(7 downto 0);
isrShifted(9 downto 2) <= instSignReduce;
isrShifted(1 downto 0) <= "00";


--Control Unit:
ctl:ControlUnit port map(opcode, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, aluCtlin); 
aluctl:AluCtrlUnit port map(instSignReduce(5 downto 0), aluCtlin, aluCtlout);

--Register File:
rf:registerFile port map(RegWrite, inst23to21, inst18to16, writeRegIn, i_writeData, i_clk, rfclr, readData1, readData2);
rtrdMux: mux2to1_3bit port map(inst18to16, inst13to11, RegDst, writeRegIn);

--ALU 
aluMux: mux2to1_8bit port map(readData2, instSignReduce, ALUSrc, aluSrcOut);
alu: alu8bit port map(readData1, aluSrcOut, aluCtlout, aluOut);
aluzero <= ('0' nor aluOut(0)) and ('0' nor aluOut(1)) and ('0' nor aluOut(2))and ('0' nor aluOut(3))and ('0' nor aluOut(4))and ('0' nor aluOut(5))and ('0' nor aluOut(6))and ('0' nor aluOut(7))  ;

--Adder
adder: CLA_top port map(i_pcplus4, isrShifted, '0', adderOut);

--branch mux
branchAnd <= aluzero and Branch; 
branchMux: mux2to1_10bit port map(i_pcplus4, adderOut, branchAnd, o_branchMuxOut);

--output driver
o_aluOut <= aluOut;
o_readData2 <= readData2;
o_memWrite <= MemWrite;
o_memToReg <= MemtoReg;
o_memRead <= MemRead;

end subtop_rtl;