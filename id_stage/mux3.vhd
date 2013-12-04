----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:09:35 11/22/2013 
-- Design Name: 
-- Module Name:    mux3 - Behavioral 
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

entity mux3 is
	port(
		reg_write_in, mem_read_in, mem_write_in: in std_logic;
		reg_dst_in: in reg_dst_type;
		mem_to_reg_in: in mem_to_reg_type;
		first_src_in: in first_src_type;
		alu_src_in: in alu_src_type;
		jump_in: in jump_type;
		alu_op_in: in alu_op_type;

		reg_write_out, mem_read_out, mem_write_out: out std_logic;
		reg_dst_out: out reg_dst_type;
		mem_to_reg_out: out mem_to_reg_type;
		first_src_out: out first_src_type;
		alu_src_out: out alu_src_type;
		jump_out: out jump_type;
		alu_op_out: out alu_op_type;

		sel: in std_logic
	);
end mux3;

architecture Behavioral of mux3 is

begin
	reg_write_out <= reg_write_in when sel = '0' else '0';
	mem_read_out <= mem_read_in when sel = '0' else '0';
	mem_write_out <= mem_write_in when sel = '0' else '0';
	jump_out <= jump_in when sel = '0' else nop;

	alu_src_out <= alu_src_in;
	first_src_out <= first_src_in;
	reg_dst_out <= reg_dst_in;
	mem_to_reg_out <= mem_to_reg_in;
	alu_op_out <= alu_op_in;
end Behavioral;

