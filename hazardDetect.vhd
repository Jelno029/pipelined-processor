LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY hazardDetect IS
	PORT (
		in_ID_EX_MemRead	  	: IN STD_LOGIC;
		in_MEM_WB_RegWrite	: IN STD_LOGIC;

      in_ID_EX_rt		 			: IN STD_LOGIC_VECTOR (4 downto 0);
		in_IF_ID_rs, in_IF_ID_rt: IN STD_LOGIC_VECTOR (4 downto 0);
		in_MEM_WB_WriteRegister	: IN STD_LOGIC_VECTOR (4 downto 0);
		in_IF_ID_op		  		: IN STD_LOGIC_VECTOR (5 downto 0);
		in_Data1_eq_Data2	  	: IN STD_LOGIC;
		
		o_controlMux, o_IF_ID_write, o_PC_write    : OUT STD_LOGIC );
END hazardDetect;

ARCHITECTURE hdu_rtl OF hazardDetect IS

	SIGNAL int_ID_EX_rt_eq_IF_ID_rs, int_ID_EX_rt_eq_IF_ID_rt, int_MEM_WB_WriteReg_eq_IF_ID_rt, int_MEM_WB_WriteReg_eq_IF_ID_rs    : STD_LOGIC;
	SIGNAL int_hazard1, int_hazard2, int_branch_stall, int_branch_if_eq	     : STD_LOGIC;

BEGIN
	--Signal Assignment

	int_ID_EX_rt_eq_IF_ID_rs <= (in_ID_EX_rt(0) XNOR in_IF_ID_rs(0)) AND (in_ID_EX_rt(1) XNOR in_IF_ID_rs(1)) AND (in_ID_EX_rt(2) XNOR in_IF_ID_rs(2));
	int_ID_EX_rt_eq_IF_ID_rt <= (in_ID_EX_rt(0) XNOR in_IF_ID_rt(0)) AND (in_ID_EX_rt(1) XNOR in_IF_ID_rt(1)) AND (in_ID_EX_rt(2) XNOR in_IF_ID_rt(2));

	int_MEM_WB_WriteReg_eq_IF_ID_rt <= (in_MEM_WB_WriteRegister(0) XNOR in_IF_ID_rt(0)) AND (in_MEM_WB_WriteRegister(1) XNOR in_IF_ID_rt(1)) AND (in_MEM_WB_WriteRegister(2) XNOR in_IF_ID_rt(2));
	int_MEM_WB_WriteReg_eq_IF_ID_rs <= (in_MEM_WB_WriteRegister(0) XNOR in_IF_ID_rs(0)) AND (in_MEM_WB_WriteRegister(1) XNOR in_IF_ID_rs(1)) AND (in_MEM_WB_WriteRegister(2) XNOR in_IF_ID_rs(2));
	
	int_hazard1 <= in_ID_EX_MemRead AND (int_ID_EX_rt_eq_IF_ID_rs OR int_ID_EX_rt_eq_IF_ID_rt);
	int_hazard2 <= in_MEM_WB_RegWrite AND (int_MEM_WB_WriteReg_eq_IF_ID_rt OR int_MEM_WB_WriteReg_eq_IF_ID_rt);

	int_branch_if_eq <= (not(in_IF_ID_op(5)) AND not(in_IF_ID_op(4)) AND not(in_IF_ID_op(3)) AND in_IF_ID_op(2) AND not(in_IF_ID_op(1)) AND not(in_IF_ID_op(0)) );
	int_branch_stall <= int_branch_if_eq AND in_Data1_eq_Data2;

	--Output Assignment
	o_controlMux 	<= int_hazard1 or int_hazard2;
	o_PC_write	<= not(int_hazard1 OR int_hazard2);
	o_IF_ID_write	<= not(int_hazard1 OR  int_hazard2 OR int_branch_stall);
	

END hdu_rtl;