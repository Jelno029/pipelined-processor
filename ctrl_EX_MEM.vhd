LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity ctrl_EX_MEM is
port(
		i_m_Branch, i_m_MemRead, i_m_MemWrite,
		i_wb_RegWrite, i_wb_MemToReg: in std_logic;
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		o_wb_RegWrite, o_wb_MemToReg: out std_logic); 
end ctrl_EX_MEM;


architecture rtl of ctrl_EX_MEM is

component mydff is
PORT(
		i_d, i_en, i_clk, i_set, i_clr : in std_logic;		-- set, clr are active-LOW. EN is active-high.
		o_q, o_qbar : OUT STD_LOGIC);
end component;

begin

bit0:mydff port map (i_wb_MemToReg, i_enload, i_clk, '1', i_clr, o_wb_MemToReg);
bit1:mydff port map (i_wb_RegWrite, i_enload, i_clk, '1', i_clr, o_wb_RegWrite);


end rtl;