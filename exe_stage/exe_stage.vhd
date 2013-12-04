----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:35:22 11/23/2013 
-- Design Name: 
-- Module Name:    exe_stage - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use WORK.CONST.ALL;

entity exe_stage is
	port(
		pc_plus_4: in std_logic_vector(31 downto 0);
		branch_pc: out std_logic_vector(31 downto 0);
		target: in std_logic_vector(25 downto 0);
		jump_pc: out std_logic_vector(31 downto 0);
		exemem_ret, memwb_ret, rs_data, rt_data, signed_15_0, unsigned_15_0, unsigned_10_6: in std_logic_vector(31 downto 0);
		exemem_rd, memwb_rd, idex_rs, idex_rt, idex_rd: in std_logic_vector(4 downto 0);
		exemem_reg_write, memwb_reg_write: in std_logic;
		idex_reg_dst: in reg_dst_type;
		first_src: in first_src_type;
		second_src: in alu_src_type;
		alu_op: in alu_op_type;
		reg_dst: out std_logic_vector(4 downto 0);
		alu_output, hi, lo, mem_dst, rs_data_out: out std_logic_vector(31 downto 0);
		
		clk, rst: in std_logic
	);
end exe_stage;

architecture Behavioral of exe_stage is
	component alu_mux is
		port(
			regimm, exemem, memwb: in std_logic_vector(31 downto 0);
			output: out std_logic_vector(31 downto 0);
			sel: in alu_mux_sel
		);
	end component;
	
	component alu is
		port(
			input1, input2: in std_logic_vector(31 downto 0);
			alu_op: in alu_op_type;
			output, hi, lo: out std_logic_vector(31 downto 0)
		);
	end component;
	
	component first_mux is
		port(
			rs, rt: in std_logic_vector(31 downto 0);
			output: out std_logic_vector(31 downto 0);
			first_src: in first_src_type
		);
	end component;
	
	component forwarding is
		port(
			exemem_rd, memwb_rd, idex_rs, idex_rt: in std_logic_vector(4 downto 0);
			exemem_reg_write, memwb_reg_write: in std_logic;
			forward_a, forward_b: out alu_mux_sel
		);
	end component;
	
	component reg_dst_mux is
		port(
			rt_reg, rd_reg: in std_logic_vector(4 downto 0);
			output: out std_logic_vector(4 downto 0);
			sel: in reg_dst_type
		);
	end component;
	
	component second_mux is
		port(
			reg_2_in, signed_15_0_in, unsigned_15_0_in, unsigned_10_6_in: in std_logic_vector(31 downto 0);
			output: out std_logic_vector(31 downto 0);
			sel: in alu_src_type
		);
	end component;
	
	signal reg_1_out, reg_2_out, first_oper, second_oper: std_logic_vector(31 downto 0);
	signal forward_a, forward_b: alu_mux_sel;
begin
	reg_1_mux: alu_mux port map(
		rs_data, exemem_ret, memwb_ret,
		reg_1_out,
		forward_a
	);
	
	reg_2_mux: alu_mux port map(
		rt_data, exemem_ret, memwb_ret,
		reg_2_out,
		forward_b
	);
	
	mux_1: first_mux port map(
		reg_1_out, reg_2_out,
		first_oper,
		first_src
	);
	
	mux_2: second_mux port map(
		reg_2_out, signed_15_0, unsigned_15_0, unsigned_10_6,
		second_oper,
		second_src
	);
	
	forw: forwarding port map(
		exemem_rd, memwb_rd, idex_rs, idex_rt,
		exemem_reg_write, memwb_reg_write,
		forward_a, forward_b
	);
	
	reg_dst_m: reg_dst_mux port map(
		idex_rt, idex_rd,
		reg_dst,
		idex_reg_dst
	);
	
	a: alu port map(
		first_oper, second_oper,
		alu_op,
		alu_output, hi, lo
	);
	
	mem_dst <= reg_2_out;
	rs_data_out <= reg_1_out;
	
	process(unsigned_15_0, pc_plus_4)
		variable temp: std_logic_vector(31 downto 0);
	begin
		if unsigned_15_0(15) = '0' then
			temp := zero_14 & unsigned_15_0(15 downto 0) & zero_2;
		else
			temp := one_14 & unsigned_15_0(15 downto 0) & zero_2;
		end if;
		branch_pc <= temp + pc_plus_4;
	end process;

	jump_pc <= pc_plus_4(31 downto 28) & target & zero_2;

end Behavioral;

