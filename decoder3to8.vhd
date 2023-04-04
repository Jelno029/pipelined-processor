LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity decoder3to8 is
port(
		i_X	:	in std_logic_vector(2 downto 0);
		o_Y	:	out std_logic_vector(7 downto 0));
end decoder3to8;


architecture decrtl of decoder3to8 is

signal x	: std_logic_vector(2 downto 0);
signal y : std_logic_vector(7 downto 0);

begin

x <= i_X;

y(0)	<=	not(x(2))	and	not(x(1))	and	not(x(0));
y(1)	<=	not(x(2))	and	not(x(1))	and	x(0);
y(2)	<=	not(x(2))	and	x(1)			and	not(x(0));
y(3)	<=	not(x(2))	and	x(1)			and	x(0);
y(4)	<=	x(2)			and	not(x(1))	and	not(x(0));
y(5)	<=	x(2)			and	not(x(1))	and	x(0);
y(6)	<=	x(2)			and	x(1)			and	not(x(0));
y(7)	<=	x(2)			and	x(1)			and	x(0);

o_Y <= y;

end decrtl;