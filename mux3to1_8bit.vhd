LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity mux3to1_8bit is
port(
		i_0, i_1, i_2	:	in std_logic_vector(7 downto 0);		-- 3 inputs, 8 bits
		i_select			:	in std_logic_vector(1 downto 0);		-- 2 selection bits
		o_output			:	out std_logic_vector(7 downto 0));	-- 1 output
end mux3to1_8bit;

architecture mux3rtl of mux3to1_8bit is

component mux2to1_8bit is
port(
		i_0, i_1	:	in std_logic_vector(7 downto 0);		-- 2 inputs, 8 bits
		i_select	:	in std_logic;								-- 1 selection bit
		o_output	:	out std_logic_vector(7 downto 0));	-- 1 output
end component;

signal mux01out, mux12out	: std_logic_vector(7 downto 0);
signal sel0, sel1	: std_logic;

begin

sel0 <= i_select(0);
sel1 <= i_select(1);

mux01:mux2to1_8bit port map(i_0, i_1, sel0, mux01out);
mux12:mux2to1_8bit port map(mux01out, i_2, sel1, mux12out);

--output driver
o_output <= mux12out;

end mux3rtl;