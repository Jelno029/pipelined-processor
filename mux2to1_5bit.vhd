LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity mux2to1_5bit is
port(
		i_0, i_1	:	in std_logic_vector(4 downto 0);		-- 2 inputs, 5 bits
		i_select	:	in std_logic;								-- 1 selection bit
		o_output	:	out std_logic_vector(4 downto 0));	-- 1 output
end mux2to1_5bit;

architecture mux2rtl of mux2to1_5bit is

signal selext	: std_logic_vector(4 downto 0);			-- extended selection bit

begin

selext	<= (others => i_select);	-- sel bit is extended to 8 bits for direct logic operations

o_output	<= (i_0 and not(selext)) or (i_1 and selext);

end mux2rtl;