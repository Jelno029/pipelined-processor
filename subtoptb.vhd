library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity subtoptb is
end subtoptb;


architecture tb_rtl of subtoptb is

component subtop is
port(
		i_instruction	:	in std_logic_vector(31 downto 0);
		i_pcplus4		:  in std_logic_vector(9  downto 0);
		i_writeData		:	in std_logic_vector(7 downto 0);
		i_clk				:	in std_logic;
		
		o_branchMuxOut	:	out std_logic_vector(9 downto 0);
		o_aluOut			:	out std_logic_vector(7 downto 0);
		o_readData2		:	out std_logic_vector(7 downto 0);
		o_memWrite		:	out std_logic;
		o_memToReg		:	out std_logic;
		o_memRead		:	out std_logic);
end component;

signal i_instruction	: std_logic_vector(31 downto 0);
signal i_pcplus4		: std_logic_vector(9  downto 0);
signal i_writeData	: std_logic_vector(7 downto 0);
signal i_clk			: std_logic := '0';
signal o_branchMuxOut: std_logic_vector(9 downto 0);
signal o_aluOut		: std_logic_vector(7 downto 0);
signal o_readData2	: std_logic_vector(7 downto 0);
signal o_memWrite		: std_logic;
signal o_memToReg		: std_logic;
signal o_memRead		: std_logic;




begin

dut:subtop port map(i_instruction, i_pcplus4, i_writeData, i_clk, o_branchMuxOut, o_aluOut, o_readData2, o_memWrite, o_memToReg, o_memRead);


process begin

	--I: LW $2,0
	i_instruction	<= "10001100000000100000000000000000";	-- 8C020000; LW $2,0 memory(00)=55
	i_pcplus4		<=	"0000000100";
	i_writeData		<= "01010101";									-- Data = 55
	wait for 5 ns;
	
	i_clk		<=	'1';
	wait for 25  ns;
	i_clk		<= '0';
	wait for 25  ns;
	
	--II: LW $3,1
	i_instruction	<= "10001100000000110000000000000001";	-- 8C030001; LW $3,1 memory(01)=AA
	i_pcplus4		<=	"0000001000";
	i_writeData		<= "10101010";									-- Data = AA
	wait for 5 ns;
	
	i_clk		<=	'1';
	wait for 25  ns;
	i_clk		<= '0';
	wait for 25  ns;
	
	
	--III: ADD data together
	i_instruction	<= "00000000010000110000100000100000";	-- 00430820; add $1,$2,$3
	i_pcplus4		<=	"0000001100";
	i_writeData		<= "11111111";	-- Sum = FF								
	wait for 5 ns;
	
	i_clk		<=	'1';
	wait for 25  ns;
	i_clk		<= '0';
	wait for 25  ns;
	
	--IV: SW 
	i_instruction	<= "10101100000000010000000000000011";	-- AC010003; sw $1,3 memory(03)=FF
	i_pcplus4		<=	"0000010000";
	i_writeData		<= "11111111";	-- Sum = FF								
	wait for 5 ns;
	
	i_clk		<=	'1';
	wait for 25  ns;
	i_clk		<= '0';
	wait for 25  ns;
	
	
	--V: BEQ (FAILS) 
	i_instruction	<= "00010000001000101111111111111111";	-- 1022FFFF; beq $1,$2,-4
	i_pcplus4		<=	"0000010100";
	i_writeData		<= o_branchMuxOut(7 downto 0);	      -- Result should be (PC+4) - 4 = 00001000					
	wait for 5 ns;
	
	i_clk		<=	'1';
	wait for 25  ns;
	i_clk		<= '0';
	wait for 25  ns;
	
	--VI: BEQ (WORKS)
	i_instruction	<= "00010000001000011111111111111010";	-- 1021FFFA; beq $1,$1,-24
	i_pcplus4		<=	"0000011000";
	i_writeData		<= o_branchMuxOut(7 downto 0);	      -- Result should be (PC+4) - 24 = 00000000 					
	wait for 5 ns;
	
	i_clk		<=	'1';
	wait for 25  ns;
	i_clk		<= '0';
	wait for 25  ns;
	
	
	end process;

end tb_rtl;
	
