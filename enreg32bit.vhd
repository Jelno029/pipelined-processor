LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity enreg32bit is
port(
		i_pinput	:	in std_logic_vector(31 downto 0); -- Parallel In
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		o_poutput: 	out std_logic_vector(31 downto 0)); -- Parallel Out
end enreg32bit;


architecture enreg_rtl of enreg32bit is

component mydff is
PORT(
		i_d, i_en, i_clk, i_set, i_clr : in std_logic;		-- set, clr are active-LOW. EN is active-high.
		o_q, o_qbar : OUT STD_LOGIC);
end component;

begin
	gen32bitreg: for i in 31 downto 0 generate
		reg32bit: mydff
		port map(i_pinput(i), i_enload, i_clk, '1', i_clr, o_poutput(i));
	end generate;

end enreg_rtl;