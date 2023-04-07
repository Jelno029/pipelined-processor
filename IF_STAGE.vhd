LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity IF_STAGE is
port(
	i_pcEn		: in std_logic;
	i_brAdd		: in std_logic_vector(9 downto 0);
	i_branchMux	: in std_logic;
	
	i_clk			: in std_logic;
	
	o_pcplus4		: out std_logic_vector(9 downto 0);
	o_instruction	: out std_logic_vector(31 downto 0));
end IF_STAGE;


architecture if_rtl of IF_STAGE is

component mux2to1_10bit is
port(
		i_0, i_1	:	in std_logic_vector(9 downto 0);		-- 2 inputs, 10 bits
		i_select	:	in std_logic;								-- 1 selection bit
		o_output	:	out std_logic_vector(9 downto 0));	-- 1 output
end component;

component enreg8bit is
port(
		i_pinput	:	in std_logic_vector(7 downto 0); -- Parallel In
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		o_poutput: 	out std_logic_vector(7 downto 0)); -- Parallel Out
end component;

component CLA_top is
port(
	A, B		: in std_logic_vector(9 downto 0);
	Cin		: in std_logic;
	S			: out std_logic_vector(9 downto 0);
	Cout		: out std_logic);
end component;

-- ========================
-- LPM ROM DECLARATION
component instMemory IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock			: IN STD_LOGIC  := '1';
		q				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;
-- ========================

signal four		: std_logic_vector(9 downto 0):= "0000000100";
signal muxout	: std_logic_vector(9 downto 0);
signal pcin		: std_LOGIC_VECTOR(7 downto 0);
signal clr		: std_logic := '0';
signal pcout	: std_logic_vector(9 downto 0);
signal aluout	: std_logic_vector(9 downto 0);
signal instr	: std_logic_vector(31 downto 0);

begin
	clr <= '1' after 1 ns;

-- COMPONENT INSTANCES
	-- MUX
		if_mux:mux2to1_10bit port map(aluout, i_brAdd, i_branchMux, muxout);	
	-- PC REGISTER
		pcin <= muxout(7 downto 0);
		if_pc:enreg8bit port map (pcin, i_pcEn, i_clk, clr,  pcout);
	-- ALU
		if_alu:CLA_top port map (pcout, four, '0', aluout);
	-- LPM ROM
		if_memory:instMemory port map(pcout, i_clk, instr);
	-- OUTPUT DRIVERS (IF NEEDED)
		o_pcplus4 <= aluout;
		o_instruction <= instr;

end if_rtl;


