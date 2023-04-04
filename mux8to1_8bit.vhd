LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity mux8to1_8bit is
port(
		i_0, i_1, i_2, i_3, i_4, i_5, i_6, i_7 : in std_logic_vector(7 downto 0);	-- 8 inputs, 8 bits
		i_select	:	in std_logic_vector(2 downto 0);											-- 1 selection bit
		o_output	:	out std_logic_vector(7 downto 0));										-- 1 output
end mux8to1_8bit;


architecture mux8rtl of mux8to1_8bit is

component mux2to1_8bit is
port(
		i_0, i_1	:	in std_logic_vector(7 downto 0);		-- 2 inputs, 8 bits
		i_select	:	in std_logic;								-- 1 selection bit
		o_output	:	out std_logic_vector(7 downto 0));	-- 1 output
end component;

signal mux01out, mux23out, mux45out, mux67out, mux0123out, mux4567out	:	std_logic_vector(7 downto 0);

begin

mux01:mux2to1_8bit port map(i_0, i_1, i_select(0), mux01out);
mux23:mux2to1_8bit port map(i_2, i_3, i_select(0), mux23out);
mux45:mux2to1_8bit port map(i_4, i_5, i_select(0), mux45out);
mux67:mux2to1_8bit port map(i_6, i_7, i_select(0), mux67out);

mux0123:mux2to1_8bit port map(mux01out, mux23out, i_select(1), mux0123out);
mux4567:mux2to1_8bit port map(mux45out, mux67out, i_select(1), mux4567out);

muxout:mux2to1_8bit port map(mux0123out, mux4567out, i_select(2), o_output);

end mux8rtl;
