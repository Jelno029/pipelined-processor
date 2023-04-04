LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity buffer_ID_EX is
port(
		i_ex_RegDst, i_ex_ALUOp1, i_ex_ALUOp0, i_ex_ALUSrc, 
		i_m_Branch, i_m_MemRead, i_m_MemWrite,
		i_wb_RegWrite, i_wb_MemToReg: in std_logic;	-- Control Inputs
		
		i_pc: in std_logic_vector(9 downto 0);
		i_data1, i_data2 : in std_logic_vector(7 downto 0);
		i_branch_offset_8bit : in std_logic_vector(7 downto 0);
		i_rs, i_rt1, i_rt2, i_rd : in std_logic_vector(4 downto 0);
		
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		
		o_m_Branch, o_m_MemRead, o_m_MemWrite,
		o_wb_RegWrite, o_wb_MemToReg: out std_logic; --Control outputs
		
		o_pc : out std_logic_vector(9 downto 0);
		o_data1, o_data2 : out std_logic_vector(7 downto 0);
		o_rs, o_rt1, o_rt2, o_rd : out std_logic_vector(4 downto 0));
		
		
end buffer_ID_EX;


architecture rtl of buffer_ID_EX is

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

component enreg10bit is
port(
		i_pinput	:	in std_logic_vector(9 downto 0); -- Parallel In
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		o_poutput: 	out std_logic_vector(9 downto 0)); -- Parallel Out
end component;

component mydff is
PORT(
		i_d, i_en, i_clk, i_set, i_clr : in std_logic;		-- set, clr are active-LOW. EN is active-high.
		o_q, o_qbar : OUT STD_LOGIC);
end component;
		
begin

ctrlBit0:mydff port map (i_m_MemWrite, i_enload, i_clk, '1', i_clr, o_m_MemWrite);
ctrlbit1:mydff port map (i_m_MemRead, i_enload, i_clk, '1', i_clr, o_m_MemRead);
ctrlbit2:mydff port map (i_m_Branch, i_enload, i_clk, '1', i_clr, o_m_Branch);
ctrlbit3:mydff port map (i_wb_MemToReg, i_enload, i_clk, '1', i_clr, o_wb_MemToReg);
ctrlbit4:mydff port map (i_wb_RegWrite, i_enload, i_clk, '1', i_clr, o_wb_RegWrite);

pcplus4:enreg10bit port map(i_pc, i_enload, i_clk, '1', o_pc);
data1reg:enreg8bit port map(i_data1, i_enload, i_clk, '1', o_data1);
data2reg:enreg8bit port map(i_data2, i_enload, i_clk, '1', o_data2);
--branchOffset:enreg8bit port map(i_branch_offset_8bit, i_enload, i_clk, '1', ?);
addrRs:enreg5bit port map(i_rs, i_enload, i_clk, '1', o_rs);
addrRt1:enreg5bit port map(i_rt1, i_enload, i_clk, '1', o_rt1);
addrRt2:enreg5bit port map(i_rt2, i_enload, i_clk, '1', o_rt2);
addrRd:enreg5bit port map(i_rd, i_enload, i_clk, '1', o_rd);

end rtl;