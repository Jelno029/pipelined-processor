LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mytff IS
	PORT(
		i_t, i_en, i_clk, i_set, i_clr : in std_logic;		-- set, clr are active-LOW. EN is active-high.
		o_q, o_qbar : OUT STD_LOGIC);
END mytff; 

ARCHITECTURE rtl OF mytff IS
	SIGNAL int_q, int_qBar, int_muxOutput : STD_LOGIC;

BEGIN

oneBitRegister:
PROCESS(i_clk, i_set, i_clr)
BEGIN
	IF (i_set = '0') THEN
		int_q <= '1';

	ELSIF (i_clr = '0') THEN
		int_q <= '0';
		
	ELSIF (rising_edge(i_clk)) THEN		-- on rising edge
		IF (i_en = '1') THEN		-- if enabled
			IF(i_t = '1') THEN	-- if t = 1 a.k.a. toggle;
				int_q <= not(int_q) after 1 ns;
			END IF;			-- otherwise no change.
		END IF;
	END IF;
END PROCESS oneBitRegister;

-- Output Driver
	o_q	<= int_q;
	o_qBar	<= int_qBar;
			
END rtl;
	

