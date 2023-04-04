LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity buffer_MEM_WB is
port(
		i_wb_RegWrite, i_wb_MemToReg: in std_logic; -- Control inputs
		i_dataMem, i_aluRes: in std_logic_vector(7 downto 0); 
		i_destAddr: in std_logic_vector(4 downto 0);
		
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		o_wb_RegWrite, o_wb_MemToReg: out std_logic; 
		
		o_dataMem, o_aluRes: out std_logic_vector(7 downto 0); 
		o_destAddr: out std_logic_vector(4 downto 0));
end buffer_MEM_WB;


architecture rtl of buffer_MEM_WB is

component mydff is
PORT(
		i_d, i_en, i_clk, i_set, i_clr : in std_logic;		-- set, clr are active-LOW. EN is active-high.
		o_q, o_qbar : OUT STD_LOGIC);
end component;

component enreg5bit is
port(
		i_pinput	:	in std_logic_vector(4 downto 0); -- Parallel In
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		o_poutput: 	out std_logic_vector(4 downto 0)); -- Parallel Out
end component;

component enreg8bit is
port(
		i_pinput	:	in std_logic_vector(7 downto 0); -- Parallel In
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		o_poutput: 	out std_logic_vector(7 downto 0)); -- Parallel Out
end component;

begin

ctrlBit0:mydff port map (i_wb_MemToReg, i_enload, i_clk, '1', i_clr, o_wb_MemToReg);
ctrlBit1:mydff port map (i_wb_RegWrite, i_enload, i_clk, '1', i_clr, o_wb_RegWrite);
dataMemory: enreg8bit port map(i_dataMem, i_enload, i_clk, '1', o_dataMem);
aluResult: enreg8bit port map(i_aluRes, i_enload, i_clk, '1', o_aluRes);
destAddress: enreg5bit port map(i_destAddr, i_enload, i_clk, '1', o_destAddr);

end rtl;