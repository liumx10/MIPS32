----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:14:45 11/23/2013 
-- Design Name: 
-- Module Name:    forwarding - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use WORK.CONST.ALL;

entity forwarding is
	port(
		exemem_rd, memwb_rd, idex_rs, idex_rt: in std_logic_vector(4 downto 0);
		exemem_reg_write, memwb_reg_write: in std_logic;
		forward_a, forward_b: out alu_mux_sel
	);
end forwarding;

architecture Behavioral of forwarding is

begin
	forward_a <=
		exemem_ret when exemem_reg_write = '1' and exemem_rd /= "00000" and exemem_rd = idex_rs else
		memwb_ret when memwb_reg_write = '1' and memwb_rd /= "00000" and memwb_rd = idex_rs else
		reg_imm;
	
	forward_b <= 
		exemem_ret when exemem_reg_write = '1' and exemem_rd /= "00000" and exemem_rd = idex_rt else
		memwb_ret when memwb_reg_write = '1' and memwb_rd /= "00000" and memwb_rd = idex_rt else
		reg_imm;
end Behavioral;

