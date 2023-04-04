LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity enreg5bit is
port(
		i_pinput	:	in std_logic_vector(4 downto 0); -- Parallel In
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		o_poutput: 	out std_logic_vector(4 downto 0)); -- Parallel Out
end enreg5bit;


architecture enreg_rtl of enreg5bit is

component mydff is
PORT(
		i_d, i_en, i_clk, i_set, i_clr : in std_logic;		-- set, clr are active-LOW. EN is active-high.
		o_q, o_qbar : OUT STD_LOGIC);
end component;

begin

bit0:mydff port map (i_pinput(0), i_enload, i_clk, '1', i_clr, o_poutput(0));
bit1:mydff port map (i_pinput(1), i_enload, i_clk, '1', i_clr, o_poutput(1));
bit2:mydff port map (i_pinput(2), i_enload, i_clk, '1', i_clr, o_poutput(2));
bit3:mydff port map (i_pinput(3), i_enload, i_clk, '1', i_clr, o_poutput(3));
bit4:mydff port map (i_pinput(4), i_enload, i_clk, '1', i_clr, o_poutput(4));

end enreg_rtl;