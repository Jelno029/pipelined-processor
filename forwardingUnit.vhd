library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity forwardingUnit is
port(
	i_id_ex_Rs, i_id_ex_Rt, i_ex_mem_Rd, i_mem_wb_Rd : in std_logic_vector(4 downto 0);
	i_ex_mem_RegWrite, i_mem_wb_RegWrite : in std_logic;
	o_forwardA, o_forwardB : out std_logic_vector(1 downto 0));
end forwardingUnit;

architecture rtl of forwardingUnit is

begin 

	--If (EX/MEM.RegWrite & (EX/MEM.RegisterRd ≠ 0) & (EX/MEM.RegisterRd=ID/EX.RegisterRs)) ForwardA= 10
	--If (EX/MEM.RegWrite & (EX/MEM.RegisterRd ≠ 0) & (EX/MEM.RegisterRd=ID/EX.RegisterRt)) ForwardB= 10
	--If (MEM/WB.RegWrite & (MEM/WB.RegisterRd ≠ 0) & (MEM/WB.RegisterRd=ID/EX.RegisterRs)) ForwardA= 01
	--If (MEM/WB.RegWrite & (MEM/WB.RegisterRd ≠ 0) & (MEM/WB.RegisterRd=ID/EX.RegisterRt)) ForwardB= 01
	
end rtl;

architecture behav of forwardingUnit is

begin
process(i_ex_mem_RegWrite, i_ex_mem_Rd, i_mem_wb_RegWrite, i_mem_wb_Rd, i_id_ex_Rs, i_id_ex_Rt) is
	begin
		if ((i_ex_mem_RegWrite = '1') 
			and (i_ex_mem_Rd /= "00000") 
			and (i_ex_mem_Rd = i_id_ex_Rs)) then
				o_forwardA <= b"10"; 
				
		elsif ((i_mem_wb_RegWrite = '1') 
			and (i_mem_wb_Rd /= "00000") 
			and not(i_ex_mem_RegWrite = '1' and (i_ex_mem_Rd /= "00000")
				and (i_ex_mem_Rd = i_id_ex_Rs))
			and (i_mem_wb_Rd = i_id_ex_Rs)) then
				o_forwardA <= b"01"; 
		else 
			o_forwardA <= b"00";
		end if;
		
		if ((i_ex_mem_RegWrite = '1') 
			and (i_ex_mem_Rd /= "00000") 
			and (i_ex_mem_Rd = i_id_ex_Rt)) then
				o_forwardB <= b"10"; 
				
		elsif ((i_mem_wb_RegWrite = '1')
			and (i_mem_wb_Rd /= "00000") 
				and not(i_ex_mem_RegWrite = '1' and (i_ex_mem_Rd /= "00000")
				and (i_ex_mem_Rd = i_id_ex_Rt))
			and (i_mem_wb_Rd = i_id_ex_Rt)) then
				o_forwardB <= b"01"; 
		else 
			o_forwardB <= b"00";
		end if;
		
	
	end process;
end behav;