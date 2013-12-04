----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:30:52 11/22/2013 
-- Design Name: 
-- Module Name:    id_stage - Behavioral 
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

entity id_stage is
	port(
		debug_in_addr: in std_logic_vector(4 downto 0);
		debug_out_data: out std_logic_vector(31 downto 0);

		inst, wr_data: in std_logic_vector(31 downto 0);

		reg_write, mem_read, mem_write: out std_logic;
		first_src: out first_src_type;
		alu_src: out alu_src_type;
		reg_dst: out reg_dst_type;
		mem_to_reg: out mem_to_reg_type;
		jump: out jump_type;
		alu_op: out alu_op_type;
		target: out std_logic_vector(25 downto 0);

		lo_write: out lo_write_type;
		hi_write: out hi_write_type;

		is_sb_out: out std_logic;

		cp0_write: out std_logic;

		tlbwi: out std_logic;

		rd_data1, rd_data2: out std_logic_vector(31 downto 0);
		clk, reset, idex_memread, memwb_reg_write: in std_logic;
		wr_addr, idex_rt, ifid_rs, ifid_rt: in std_logic_vector(4 downto 0);
		pc_write, ifid_write: out std_logic;
		signed_15_0, unsigned_15_0, unsigned_10_6: out std_logic_vector(31 downto 0);

		idex_reg_write: in std_logic;
		idex_mem_to_reg: in mem_to_reg_type
	);
end id_stage;

architecture Behavioral of id_stage is
	component registers is
		port(
			debug_in_addr: in std_logic_vector(4 downto 0);
			debug_out_data: out std_logic_vector(31 downto 0);

			clk, reset, wr_en: in std_logic;
			wr_addr, rd_addr1, rd_addr2: in std_logic_vector(4 downto 0);
			wr_data: in std_logic_vector(31 downto 0);
			rd_data1, rd_data2: out std_logic_vector(31 downto 0)
		);
	end component;
	
	component control is
		port(
			code, func: in std_logic_vector(5 downto 0);
			rs_reg, rt_reg: in std_logic_vector(4 downto 0);
			reg_write, mem_read, mem_write: out std_logic;
			mem_to_reg: out mem_to_reg_type;
			reg_dst: out reg_dst_type;
			alu_src: out alu_src_type;
			first_src: out first_src_type;
			jump: out jump_type;
			alu_op: out alu_op_type;

			hi_write: out hi_write_type;
			lo_write: out lo_write_type;

			is_sb: out std_logic;

			cp0_write: out std_logic;
			tlbwi: out std_logic
		);
	end component;
	
	component hazard_unit is
		port(
			idex_memread: in std_logic;
			idex_rt, ifid_rs, ifid_rt: in std_logic_vector(4 downto 0);
			mux3_sel, pc_write, ifid_write: out std_logic;

			is_sb: in std_logic;

			idex_reg_write: in std_logic;
			idex_mem_to_reg: in mem_to_reg_type
		);
	end component;
	
	component mux3 is
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
	end component;
	
	signal reg_write_sig, mem_read_sig, mem_write_sig: std_logic;
	signal reg_dst_sig: reg_dst_type;
	signal mem_to_reg_sig: mem_to_reg_type;
	signal alu_src_sig: alu_src_type;
	signal first_src_sig: first_src_type;
	signal jump_sig: jump_type;
	signal alu_op_sig: alu_op_type;
	signal mux3_sel: std_logic;
	signal is_sb: std_logic;
begin
	reg: registers port map(
		debug_in_addr,
		debug_out_data,

		clk, reset, memwb_reg_write, 
		wr_addr, inst(25 downto 21), inst(20 downto 16),
		wr_data,
		rd_data1, rd_data2
	);
	
	con: control port map(
		inst(31 downto 26), inst(5 downto 0),
		inst(25 downto 21), inst(20 downto 16),
		reg_write_sig, mem_read_sig, mem_write_sig,
		mem_to_reg_sig,
		reg_dst_sig,
		alu_src_sig,
		first_src_sig,
		jump_sig,
		alu_op_sig,

		hi_write, lo_write,

		is_sb,
		cp0_write,
		tlbwi
	);
	
	haz: hazard_unit port map(
		idex_memread,
		idex_rt, ifid_rs, ifid_rt,
		mux3_sel, pc_write, ifid_write,

		is_sb,

		idex_reg_write,
		idex_mem_to_reg
	);
	
	mux: mux3 port map(
		reg_write_sig, mem_read_sig, mem_write_sig,
		reg_dst_sig,
		mem_to_reg_sig,
		first_src_sig,
		alu_src_sig,
		jump_sig,
		alu_op_sig,

		reg_write, mem_read, mem_write,
		reg_dst,
		mem_to_reg,
		first_src,
		alu_src,
		jump,
		alu_op,
		
		mux3_sel
	);
	
	signed_15_0 <=
		x"0000" & inst(15 downto 0) when inst(15) = '0' else
		x"FFFF" & inst(15 downto 0);
	
	unsigned_15_0 <= x"0000" & inst(15 downto 0);
	
	unsigned_10_6 <= x"0000" & "00000000000" & inst(10 downto 6);

	target <= inst(25 downto 0);

	is_sb_out <= is_sb;

end Behavioral;

