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
		
		o_hdu_opcode	:
		o_hdu_regeq		:
		o_ctlBits		: out std_logic_vector(8 downto 0);
		
		o_readData1		: out std_logic_vector(7 downto 0);
		o_readData2		: out std_logic_vector(7 downto 0);
		o_signExtend	: out std_logic_vector(7 downto 0);
		o_rs, o_rt		: out std_logic_vector(4 downto 0); -- ! RT will connect to two inputs in the next buffer !
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

