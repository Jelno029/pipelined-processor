LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity buffer_EX_MEM is
port(

		i_m_ctrl : in std_logic_vector(2 downto 0);
		i_wb_ctrl : in std_logic_vector(1 downto 0);	-- Control Inputs
		
		i_aluRes : in std_logic_vector(7 downto 0);
		i_destAddr : in std_logic_vector(4 downto 0);
		
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		
		o_m_ctrl: out std_logic_vector(2 downto 0);
		o_wb_ctrl: out std_logic_vector(1 downto 0); --Control outputs
		
		o_aluRes : out std_logic_vector(7 downto 0);
		o_destAddr : out std_logic_vector(4 downto 0));
end buffer_EX_MEM;


architecture rtl of buffer_EX_MEM is

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

Branch:mydff port map (i_m_ctrl(2), i_enload, i_clk, '1', i_clr, o_m_ctrl(2));
MemRead:mydff port map (i_m_ctrl(1), i_enload, i_clk, '1', i_clr, o_m_ctrl(1));
MemWrite:mydff port map (i_m_ctrl(0), i_enload, i_clk, '1', i_clr, o_m_ctrl(0));

RegWrite:mydff port map (i_wb_ctrl(1), i_enload, i_clk, '1', i_clr, o_wb_ctrl(1));
MemToReg:mydff port map (i_wb_ctrl(0), i_enload, i_clk, '1', i_clr, o_wb_ctrl(0));

aluResult: enreg8bit port map(i_aluRes, i_enload, i_clk, '1', o_aluRes);
destAddress: enreg5bit port map(i_destAddr, i_enload, i_clk, '1', o_destAddr);

end rtl;