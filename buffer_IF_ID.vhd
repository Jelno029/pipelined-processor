LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity buffer_IF_ID is
port(
		i_pc: in std_logic_vector(9 downto 0);
		i_instr: in std_logic_vector(31 downto 0);
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		o_pc: out std_logic_vector(9 downto 0);
		o_instr: out std_logic_vector(31 downto 0)); 
end buffer_IF_ID;


architecture rtl of buffer_IF_ID is

component enreg10bit is
port(
		i_pinput	:	in std_logic_vector(9 downto 0); -- Parallel In
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		o_poutput: 	out std_logic_vector(9 downto 0));
end component;

component enreg32bit is
port(
		i_pinput	:	in std_logic_vector(31 downto 0); -- Parallel In
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		o_poutput: 	out std_logic_vector(31 downto 0));
end component;

signal int_pc: std_logic_vector(9 downto 0);
signal int_instr: std_logic_vector(31 downto 0);

begin

pc_plus_4 : enreg10bit port map (int_pc, i_enload, i_clk, i_clr, o_pc);
instruction32bits : enreg32bit port map (int_instr, i_enload, i_clk, i_clr, o_instr);

int_pc <= i_pc;
int_instr <= i_instr;

end rtl;