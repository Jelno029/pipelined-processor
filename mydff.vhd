--------------------------------------------------------------------------------
-- Title         : Type D Flip-Flop - Fully featured realization
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : mydff.vhd
-- Author        : Joseph El-Nouni building on the work of Rami Abielmona
-- Created       : 2003/05/17
-- Last modified : 2023/02/08
-------------------------------------------------------------------------------
-- Description : This file creates a flip-flop of type D as defined in the VHDL
--		 Synthesis lecture.  The architecture is done at a MIXED abstraction level.
--		 Its defining features are the inclusion of SET, CLR, and ENABLE inputs.
-------------------------------------------------------------------------------
-- Modification history :
-- 2003.05.17 	R. Abielmona		Creation
-- 2004.09.22 	R. Abielmona		Ported for CEG 3550
-- 2007.09.25 	R. Abielmona		Modified copyright notice
-- 2023.02.08	J. El-Nouni			Modified original file.
-------------------------------------------------------------------------------
-- This file is copyright material of Rami Abielmona, Ph.D., P.Eng., Chief Research
-- Scientist at Larus Technologies.  Permission to make digital or hard copies of part
-- or all of this work for personal or classroom use is granted without fee
-- provided that copies are not made or distributed for profit or commercial
-- advantage and that copies bear this notice and the full citation of this work.
-- Prior permission is required to copy, republish, redistribute or post this work.
-- This notice is adapted from the ACM copyright notice.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mydff IS
	PORT(
		i_d, i_en, i_clk, i_set, i_clr : in std_logic;		-- set, clr are active-LOW. EN is active-high.
		o_q, o_qbar : OUT STD_LOGIC);
END mydff;

ARCHITECTURE rtl OF mydff IS
	SIGNAL int_q : STD_LOGIC;

BEGIN

oneBitRegister:
PROCESS(i_clk, i_clr, i_set)
BEGIN
	IF (i_set = '0') THEN
		int_q <= '1';

	ELSIF (i_clr = '0') THEN
		int_q <= '0';
		
	ELSIF (rising_edge(i_clk)) THEN
		IF (i_en = '1') THEN
			int_q <= i_d after 1 ns;
		END IF;
	END IF;
END PROCESS oneBitRegister;

	--  Output Driver

	o_q	<=	int_q;
	o_qBar	<=	not(int_q);

END rtl;
