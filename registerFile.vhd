LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity registerFile is
port(
		i_regWrite	:	in std_logic;
		i_readReg1	:	in std_logic_vector(2 downto 0);
		i_readReg2	:	in std_logic_vector(2 downto 0);
		i_writeReg	:	in std_logic_vector(2 downto 0);
		i_writeData	:	in std_logic_vector(7 downto 0);
		
		i_clk, i_clr	:	in std_logic;
		
		o_readData1	:	out std_logic_vector(7 downto 0);
		o_readData2	:	out std_logic_vector(7 downto 0));

end registerFile;



architecture regFile_rtl of registerFile is

-- Components
component enreg8bit is
port(
		i_pinput	:	in std_logic_vector(7 downto 0); -- Parallel In
		i_enload	:	in std_logic;							-- Load Enable
		i_clk		:	in std_logic;							-- Clock
		i_clr		:	in std_logic;							-- Clear
		o_poutput: 	out std_logic_vector(7 downto 0)); -- Parallel Out
end component;

component mux8to1_8bit is
port(
		i_0, i_1, i_2, i_3, i_4, i_5, i_6, i_7 : in std_logic_vector(7 downto 0);	-- 8 inputs, 8 bits
		i_select	:	in std_logic_vector(2 downto 0);											-- 1 selection bit
		o_output	:	out std_logic_vector(7 downto 0));	
end component;

component decoder3to8 is
port(
		i_X	:	in std_logic_vector(2 downto 0);
		o_Y	:	out std_logic_vector(7 downto 0));
end component;




-- Signals

signal in0, in1, in2, in3, in4, in5, in6, in7			:	std_logic_vector(7 downto 0);
signal out0, out1, out2, out3, out4, out5, out6, out7	:	std_logic_vector(7 downto 0);
signal loadEnable	: std_logic_vector(7 downto 0);
signal regWriteExt: std_logic_vector(7 downto 0);
signal decOut		: std_logic_vector(7 downto 0);


begin

regWriteExt <= (others => i_regWrite);
loadEnable	<= regWriteExt and decOut;

--Registers
reg0:enreg8bit port map(in0, loadEnable(0), i_clk, i_clr, out0);
reg1:enreg8bit port map(in1, loadEnable(1), i_clk, i_clr, out1);
reg2:enreg8bit port map(in2, loadEnable(2), i_clk, i_clr, out2);
reg3:enreg8bit port map(in3, loadEnable(3), i_clk, i_clr, out3);
reg4:enreg8bit port map(in4, loadEnable(4), i_clk, i_clr, out4);
reg5:enreg8bit port map(in5, loadEnable(5), i_clk, i_clr, out5);
reg6:enreg8bit port map(in6, loadEnable(6), i_clk, i_clr, out6);
reg7:enreg8bit port map(in7, loadEnable(7), i_clk, i_clr, out7);

--Decoder
dec:decoder3to8 port map(i_writeReg, decOut);

--writeData connects to all inputs:
in0 <= i_writeData;
in1 <= i_writeData;
in2 <= i_writeData;
in3 <= i_writeData;
in4 <= i_writeData;
in5 <= i_writeData;
in6 <= i_writeData;
in7 <= i_writeData;

--MUX layer / Output Driver:

muxReg1:mux8to1_8bit port map(out0, out1, out2, out3, out4, out5, out6, out7, i_readReg1, o_readData1);
muxReg2:mux8to1_8bit port map(out0, out1, out2, out3, out4, out5, out6, out7, i_readReg2, o_readData2);

end regFile_rtl;


