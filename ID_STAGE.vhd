LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity ID_STAGE is
port(
		i_hdu_ctlmux	: in std_logic;
		i_pcplus4		: in std_logic_vector(9 downto 0);
		i_instruction	: in std_logic_vector(31 downto 0);
		
		i_writeEn		: in std_logic;
		i_writeReg		: in std_logic_vector(4 downto 0);
		i_writeData		: in std_logic_vector(7 downto 0);
		
		i_clk				: in std_logic;
		
		o_hdu_opcode	: out std_logic_vector(6 downto 0);
		o_hdu_regeq		: out std_logic;
		
		o_ctl_ex			: out std_logic_vector(3 downto 0);
		o_ctl_m			: out std_logic_vector(2 downto 0);
		o_ctl_wb			: out std_logic_vector(1 downto 0);
		
		o_readData1		: out std_logic_vector(7 downto 0);
		o_readData2		: out std_logic_vector(7 downto 0);
		o_signExtend	: out std_logic_vector(7 downto 0);
		o_rs, o_rt		: out std_logic_vector(4 downto 0)); -- ! RT will connect to two inputs in the next buffer !
end ID_STAGE;
		--o_ex_RegDst		: out std_logic;
		--o_ex_ALUOp1		: out std_logic;
		--o_ex_ALUOp0		: out std_logic;
		--o_ex_ALUSrc		: out std_logic;
		--o_m_Branch		: out std_logic;
		--o_m_MemRead		: out std_logic;
		--o_m_MemWrite		: out std_logic;
		--o_wb_RegWrite	: out std_logic;
		--o_wb_MemToReg	: out std_logic;	-- Control Outputs from bit 8 to 0
		
architecture id_rtl of id_STAGE is

-- components here
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
	op: in std_logic_vector(5 downto 0);
	RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch: out std_logic;
	ALUOp	: out std_logic_vector(1 downto 0)
);
end component;

component CLA_top is
port(
	A, B: in std_logic_vector(9 downto 0);
	Cin: in std_logic;
	S: out std_logic_vector(9 downto 0);
	Cout: out std_logic);
end component;

component mux2to1_9bit is
port(
		i_0, i_1	:	in std_logic_vector(8 downto 0);		-- 2 inputs, 9 bits
		i_select	:	in std_logic;								-- 1 selection bit
		o_output	:	out std_logic_vector(8 downto 0));	-- 1 output
end component;

-- signals here

signal opcode		:	std_logic_vector(5 downto 0);	-- inst(31-26)
signal rs, rt		:	std_logic_vector(4 downto 0); -- inst(25-21) -- inst(20-16)
signal readReg1	:	std_logic_vector(2 downto 0);	-- 3-bit equivalents of rs, rt
signal readReg2	:	std_logic_vector(2 downto 0); -- ^^^
signal rd			:	std_logic_vector(15 downto 0);-- inst(15-0)
signal rdSignExt	:	std_logic_vector(7 downto 0);	-- inst(7-0)
signal rdShifted	:	std_logic_vector(9 downto 0);	-- rdSignExt shift twice to the left
signal readData1	:	std_logic_vector(7 downto 0);
signal readData2	:	std_logic_vector(7 downto 0);
signal clr, regEqual	:	std_logic;
signal branchAddress :	std_logic_vector(9 downto 0);
signal ctlVector	: std_logic_vector(8 downto 0);
signal flush		: std_logic_vector(8 downto 0):= "000000000";
signal flushOut	: std_logic_vector(8 downto 0);
signal compData	: std_logic_vector(7 downto 0);

begin
clr <= '1'; 
clr <= '0' after 2 ns;
-- Separate the Instruction:
opcode <= i_instruction(31 downto 26);
rs <= i_instruction(25 downto 21);
rt <= i_instruction(20 downto 16);
readReg1 <= rs(2 downto 0);
readReg2 <= rd(2 downto 0);
rd <= i_instruction(15 downto 0);

-- Sign extension and left-shift:
rdSignExt <= rd(7 downto 0);
rdShifted(9 downto 2) <= rd;
rdShifted(1 downto 0) <= "00";

-- register file:
regFile:registerFile	 port map (i_writeEn, readReg1, readReg2, i_writeReg, i_writeData, i_clk, clr, readData1, readData2);
-- adder:
brAdder:CLA_top 		 port map (i_pcplus4, rdShifted, '0', branchAddress);
-- control unit:
ctlUnit:ControlUnit	 port map (opcode, ctlVector(8), ctlVector(5), ctlVector(0), ctlVector(1), ctlVector(3), ctlVector(2), ctlVector(4), ctlVector(7 downto 6));
-- flush mux:
flushMux:mux2to1_9bit port map (ctlVector, flush, i_hdu_ctlmux, flushOut);
-- data equality check:
compData <= readData1 xor readData2;
regEqual <= not(compData(7) or compData(6) or compData(5) or compData(4) or compData(3) or compData(2) or compData(1) or compData(0));

-- output drivers:
		
		o_hdu_opcode	<= opcode;
		o_hdu_regeq		<= regEqual;
		
		o_ctl_ex			<= flushOut(8 downto 5);
		o_ctl_m			<= flushOut(4 downto 2);
		o_ctl_wb			<= flushOut(1 downto 0);
		
		o_readData1		<= readData1;
		o_readData2		<= readData2;
		o_signExtend	<= rdSignExt;
		
		o_rs				<= rs;
		o_rt				<= rt;

end id_rtl;