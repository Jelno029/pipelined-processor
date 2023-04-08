LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity EX_STAGE is
port(
		i_ctl_ex		: in std_logic_vector(3 downto 0);
		i_readData1	: in std_logic_vector(7 downto 0);
		i_readData2	: in std_logic_vector(7 downto 0);
		i_signExt	: in std_logic_vector(7 downto 0);
		
		i_fwd_top_mem	: in std_logic_vector(7 downto 0);
		i_fwd_top_wb	: in std_logic_vector(7 downto 0);
		i_fwd_top_mux	: in std_logic_vector(1 downto 0);
		i_fwd_bot_mem	: in std_logic_vector(7 downto 0);
		i_fwd_bot_wb	: in std_logic_vector(7 downto 0);
		i_fwd_bot_mux	: in std_logic_vector(1 downto 0);
		
		o_aluZero	: out std_logic;
		o_aluOut		: out std_logic_vector(7 downto 0);
		o_writeData	: out std_logic_vector(7 downto 0));
end EX_STAGE;

architecture ex_rtl of EX_STAGE is

component alu8bit is
port(
		i_op1, i_op2	: in std_logic_vector(7 downto 0);
		i_aluOp			: in std_logic_vector(2 downto 0);
		o_aluOut			: out std_logic_vector(7 downto 0));
end component;

component aluCtrlUnit is
port(
	i_F: in std_logic_vector(5 downto 0);
	i_ALUOp: in std_logic_vector(1 downto 0);
	o_op: out std_logic_vector(2 downto 0));
end component;

component mux2to1_8bit is
port(
		i_0, i_1	:	in std_logic_vector(7 downto 0);		-- 2 inputs, 8 bits
		i_select	:	in std_logic;								-- 1 selection bit
		o_output	:	out std_logic_vector(7 downto 0));	-- 1 output
end component;

component mux2to1_5bit is
port(
		i_0, i_1	:	in std_logic_vector(4 downto 0);		-- 2 inputs, 5 bits
		i_select	:	in std_logic;								-- 1 selection bit
		o_output	:	out std_logic_vector(4 downto 0));	-- 1 output
end component;

component mux3to1_8bit is
port(
		i_0, i_1, i_2	:	in std_logic_vector(7 downto 0);		-- 3 inputs, 8 bits
		i_select			:	in std_logic_vector(1 downto 0);		-- 2 selection bits
		o_output			:	out std_logic_vector(7 downto 0));	-- 1 output
end component;
-- signals
signal functField		: std_logic_vector(5 downto 0);
signal topmuxout, botmuxout, aluInB, aluOut	: std_logic_vector(7 downto 0);
signal aluOp			: std_logic_vector(2 downto 0);
signal aluZero			: std_logic;

begin

--alu control:
aluCtl:aluCtrlUnit port map(functField, i_ctl_ex(2 downto 1), aluOp);
--multiplexers:
topMux3to1:mux3to1_8bit port map(i_readData1, i_fwd_top_mem, i_fwd_top_wb, i_fwd_top_mux, topmuxout);
botMux3to1:mux3to1_8bit port map(i_readData2, i_fwd_bot_mem, i_fwd_bot_wb, i_fwd_bot_mux, botmuxout);
muxAluInB: mux2to1_8bit port map(botmuxout, i_signExt, i_ctl_ex(0), aluInB);
--the alu:
myalu:alu8bit port map(topmuxout, aluInB, aluOp, aluOut);
--alu zero signal:
aluZero <= not(aluOut(7) or aluOut(6) or aluOut(5) or aluOut(4) or aluOut(3) or aluOut(2) or aluOut(1) or aluOut(0));

--outputs:
o_aluOut		<= aluOut;
o_aluZero	<= aluZero;

end ex_rtl;

