----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:09:47 11/23/2013 
-- Design Name: 
-- Module Name:    cpu - Behavioral 
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

entity cpu is
	port(
		start_addr: in std_logic_vector(31 downto 0);
		debug_in_addr: in std_logic_vector(4 downto 0);
		debug_out_data: out std_logic_vector(31 downto 0);

		clk, rst: in std_logic;
		mmu_data: in std_logic_vector(31 downto 0);
		addr: out std_logic_vector(31 downto 0);
		wr: out std_logic;
		write_data: out std_logic_vector(31 downto 0);

		tlb: out tlb_file;
		
		pc_debug: out std_logic_vector(31 downto 0);
		mmu_debug: out std_logic_vector(31 downto 0);
		ifid_debug: out std_logic_vector(31 downto 0);

		data_ready, tlb_missing: in std_logic;

		cp0_data_debug: out std_logic_vector(31 downto 0);
		cp0_addr_debug: in std_logic_vector(4 downto 0)
	);
end cpu;

architecture Behavioral of cpu is
	component mmu_mux is
		port(
			inst_addr, data_addr: in std_logic_vector(31 downto 0);
			wr, rd: in std_logic;
			bus_addr: out std_logic_vector(31 downto 0);
			bus_wr, pc_write, ifid_clear: out std_logic
		);
	end component;

	component if_stage is
		port(
		   start_addr: in std_logic_vector(31 downto 0);
			pc_plus_4, inst: out std_logic_vector(31 downto 0);
			pc_src, pc_write, reset, clk: in std_logic;
			jump_pc: in std_logic_vector(31 downto 0);
			mmu_data: in std_logic_vector(31 downto 0);
			inst_bus_addr: out std_logic_vector(31 downto 0);
			pc_write_2: in std_logic;
			pc_debug: out std_logic_vector(31 downto 0)
		);
	end component;
	
	component ifid is
		port(
			pc_plus_4_in, inst_in: in std_logic_vector(31 downto 0);
			pc_plus_4_out, inst_out: out std_logic_vector(31 downto 0);
			clk, reset, wr_en, clear, clear_2, is_sb_id_out: in std_logic
		);
	end component;
	
	component id_stage is
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
	end component;
	
	component idex is
		port(
			pc_plus_4_in: in std_logic_vector(31 downto 0);
			reg_dst_in: in reg_dst_type;
			reg_write_in, mem_read_in, mem_write_in: in std_logic;
			mem_to_reg_in: in mem_to_reg_type;
			first_src_in: in first_src_type;
			second_src_in: in alu_src_type;
			jump_in: in jump_type;
			alu_op_in: in alu_op_type;
			rs_in, rt_in, rd_in: in std_logic_vector(4 downto 0);
			rs_data_in, rt_data_in: in std_logic_vector(31 downto 0);
			signed_15_0_in, unsigned_15_0_in, unsigned_10_6_in: in std_logic_vector(31 downto 0);
			target_in: in std_logic_vector(25 downto 0);
			hi_write_in: in hi_write_type;
			lo_write_in: in lo_write_type;
			is_sb_in: in std_logic;
			cp0_write_in: in std_logic;
			tlbwi_in: in std_logic;
			
			clk, rst, clear: in std_logic;
			
			pc_plus_4: out std_logic_vector(31 downto 0);
			reg_dst: out reg_dst_type;
			reg_write, mem_read, mem_write: out std_logic;
			mem_to_reg: out mem_to_reg_type;
			first_src: out first_src_type;
			second_src: out alu_src_type;
			jump: out jump_type;
			alu_op: out alu_op_type;
			rs, rt, rd: out std_logic_vector(4 downto 0);
			rs_data, rt_data: out std_logic_vector(31 downto 0);
			signed_15_0, unsigned_15_0, unsigned_10_6: out std_logic_vector(31 downto 0);
			target: out std_logic_vector(25 downto 0);
			hi_write: out hi_write_type;
			lo_write: out lo_write_type;
			is_sb: out std_logic;
			cp0_write: out std_logic;
			tlbwi: out std_logic
		);
	end component;
	
	component exe_stage is
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
	end component;
	
	component exmem is
		port(
			clk, rst, clear, sb_second: in std_logic;

			read_data, rt_data, addr_sb: in std_logic_vector(31 downto 0);
			
			pc_plus_4_in: in std_logic_vector(31 downto 0);
			branch_pc_in, jump_pc_in: in std_logic_vector(31 downto 0);
			jump_in: in jump_type;
			reg_write_in, mem_read_in, mem_write_in: in std_logic;
			mem_to_reg_in: in mem_to_reg_type;
			alu_out_in, wr_data_in: in std_logic_vector(31 downto 0);
			reg_dst_in: in std_logic_vector(4 downto 0);
			hi_in, lo_in: in std_logic_vector(31 downto 0);
			is_sb_in: in std_logic;
			cs_in: in std_logic_vector(4 downto 0);
			cp0_write_in: in std_logic;
			tlbwi_in: in std_logic;
			hi_write_in: in hi_write_type;
			lo_write_in: in lo_write_type;
			rs_data_in: in std_logic_vector(31 downto 0);
			
			pc_plus_4: out std_logic_vector(31 downto 0);
			branch_pc, jump_pc: out std_logic_vector(31 downto 0);
			jump: out jump_type;
			reg_write, mem_read, mem_write: out std_logic;
			mem_to_reg: out mem_to_reg_type;
			addr, wr_data: out std_logic_vector(31 downto 0);
			reg_dst: out std_logic_vector(4 downto 0);
			hi, lo: out std_logic_vector(31 downto 0);
			is_sb: out std_logic;
			cs: out std_logic_vector(4 downto 0);
			cp0_write: out std_logic;
			tlbwi: out std_logic;
			hi_write: out hi_write_type;
			lo_write: out lo_write_type;
			rs_data: out std_logic_vector(31 downto 0)
		);
	end component;
	
	component mem_stage is
		port(
			branch_pc_in, jump_pc_in: in std_logic_vector(31 downto 0);
			jump: in jump_type;
			alu_in, write_data: in std_logic_vector(31 downto 0);
			read_data, alu_out: out std_logic_vector(31 downto 0);
			mem_write, mem_read: in std_logic;
			next_pc: out std_logic_vector(31 downto 0);
			pc_sel, clear: out std_logic;

			mem_bus_addr: out std_logic_vector(31 downto 0);
			mmu_data: in std_logic_vector(31 downto 0);
			bus_rd, bus_wr: out std_logic;
			write_data_out: out std_logic_vector(31 downto 0);

			is_sb: in std_logic;
			read_data_to_exmem, rt_data_to_exmem, 
				addr_sb_to_exmem: out std_logic_vector(31 downto 0);
			sb_second: out std_logic;

			pc_plus_4_in: in std_logic_vector(31 downto 0);
			global_bus_addr: in std_logic_vector(31 downto 0);
			clk, rst: in std_logic;
			cp0_rd_addr: in std_logic_vector(4 downto 0);
			cp0_rd_data: out std_logic_vector(31 downto 0);

			cp0_write: in std_logic;
			tlbwi: in std_logic;

			tlb_out: out tlb_file;

			hi_write: in hi_write_type;
			lo_write: in lo_write_type;
			rs_data: in std_logic_vector(31 downto 0);
			hi_out, lo_out: out std_logic_vector(31 downto 0);
			alu_hi, alu_lo: in std_logic_vector(31 downto 0);

			data_ready, tlb_missing, rw: in std_logic;
			pc_plus_4_idex_out, pc_plus_4_ifid_out, pc_plus_4_if_out: in std_logic_vector(31 downto 0);

			cp0_data_debug: out std_logic_vector(31 downto 0);
			cp0_addr_debug: in std_logic_vector(4 downto 0);

			block_reg_write: out std_logic
		);
	end component;
	
	component memwb is
		port(
			clk, rst: in std_logic;
			
			pc_plus_4_in: in std_logic_vector(31 downto 0);
			alu_ret_in, mem_data_in: in std_logic_vector(31 downto 0);
			reg_dst_in: in std_logic_vector(4 downto 0);
			reg_write_in: in std_logic;
			mem_to_reg_in: in mem_to_reg_type;
			hi_in, lo_in: in std_logic_vector(31 downto 0);
			cp0_data_in: in std_logic_vector(31 downto 0);
			
			pc_plus_4: out std_logic_vector(31 downto 0);
			alu_ret, mem_data: out std_logic_vector(31 downto 0);
			reg_dst: out std_logic_vector(4 downto 0);
			reg_write: out std_logic;
			mem_to_reg: out mem_to_reg_type;
			hi, lo: out std_logic_vector(31 downto 0);
			cp0_data: out std_logic_vector(31 downto 0);

			block_reg_write: in std_logic
		);
	end component;
	
	component wb_stage is
		port(
			pc_plus_4: in std_logic_vector(31 downto 0);
			mem_to_reg: in mem_to_reg_type;
			read_data, alu_in, lo_in, hi_in, cp0_in: in std_logic_vector(31 downto 0);
			write_data: out std_logic_vector(31 downto 0)
		);
	end component;

	-- mmu_mux out
	signal pc_write_mmumux_out, ifid_clear_mmumux_out: std_logic;
	signal global_addr_mmumux_out: std_logic_vector(31 downto 0);
	signal wr_mmumux_out: std_logic;
	
	-- if out
	signal pc_plus_4_if_out, inst_if_out: std_logic_vector(31 downto 0);
	signal inst_bus_addr_if_out: std_logic_vector(31 downto 0);
	
	-- ifid out
	signal pc_plus_4_ifid_out, inst_ifid_out: std_logic_vector(31 downto 0);
	
	-- id out
	signal tlbwi_id_out: std_logic;
	signal cp0_write_id_out: std_logic;
	signal is_sb_id_out: std_logic;
	signal lo_write_id_out: lo_write_type;
	signal hi_write_id_out: hi_write_type;
	signal pc_write_id_out: std_logic;
	signal ifid_write_id_out: std_logic;
	signal reg_dst_id_out: reg_dst_type;
	signal mem_to_reg_id_out: mem_to_reg_type;
	signal reg_write_id_out, mem_read_id_out, mem_write_id_out: std_logic;
	signal second_src_id_out: alu_src_type;
	signal first_src_id_out: first_src_type;
	signal jump_id_out: jump_type;
	signal alu_op_id_out: alu_op_type;
	signal target_id_out: std_logic_vector(25 downto 0);
	signal rd_data1_id_out, rd_data2_id_out: std_logic_vector(31 downto 0);
	signal signed_15_0_id_out, unsigned_15_0_id_out, unsigned_10_6_id_out: std_logic_vector(31 downto 0);
	
	-- idex out
	signal tlbwi_idex_out: std_logic;
	signal cp0_write_idex_out: std_logic;
	signal is_sb_idex_out: std_logic;
	signal hi_write_idex_out: hi_write_type;
	signal lo_write_idex_out: lo_write_type;
	signal pc_plus_4_idex_out: std_logic_vector(31 downto 0);
	signal reg_dst_idex_out: reg_dst_type;
	signal reg_write_idex_out, mem_read_idex_out, mem_write_idex_out: std_logic;
	signal mem_to_reg_idex_out: mem_to_reg_type;
	signal first_src_idex_out: first_src_type;
	signal second_src_idex_out: alu_src_type;
	signal jump_idex_out: jump_type;
	signal alu_op_idex_out: alu_op_type;
	signal rs_idex_out, rd_idex_out, rt_idex_out: std_logic_vector(4 downto 0);
	signal rs_data_idex_out, rt_data_idex_out: std_logic_vector(31 downto 0);
	signal signed_15_0_idex_out, unsigned_15_0_idex_out, unsigned_10_6_idex_out: std_logic_vector(31 downto 0);
	signal target_idex_out: std_logic_vector(25 downto 0);
	
	-- ex out
	signal branch_pc_exe_out: std_logic_vector(31 downto 0);
	signal jump_pc_exe_out: std_logic_vector(31 downto 0);
	signal reg_dst_exe_out: std_logic_vector(4 downto 0);
	signal alu_exe_out, hi_exe_out, lo_exe_out, mem_dst_exe_out, rs_data_exe_out: std_logic_vector(31 downto 0);
	
	-- exmem out
	signal tlbwi_exemem_out: std_logic;
	signal cp0_write_exemem_out: std_logic;
	signal is_sb_exemem_out: std_logic;
	signal hi_exemem_out, lo_exemem_out: std_logic_vector(31 downto 0);
	signal pc_plus_4_exemem_out: std_logic_vector(31 downto 0);
	signal branch_pc_exemem_out, jump_pc_exemem_out: std_logic_vector(31 downto 0);
	signal jump_exemem_out: jump_type;
	signal reg_write_exemem_out, mem_read_exemem_out, mem_write_exemem_out: std_logic;
	signal mem_to_reg_exemem_out: mem_to_reg_type;
	signal addr_exemem_out, wr_data_exemem_out: std_logic_vector(31 downto 0);
	signal reg_dst_exemem_out: std_logic_vector(4 downto 0);
	signal cs_exemem_out: std_logic_vector(4 downto 0);
	signal hi_write_exemem_out: hi_write_type;
	signal lo_write_exemem_out: lo_write_type;
	signal rs_data_exemem_out: std_logic_vector(31 downto 0);
	
	-- mem out
	signal read_data_to_exemem_mem_out, rt_data_to_exemem_mem_out,
		addr_sb_to_exemem_mem_out: std_logic_vector(31 downto 0);
	signal sb_second_mem_out: std_logic;
	signal jump_pc_mem_out: std_logic_vector(31 downto 0);
	signal pc_src_mem_out: std_logic;
	signal read_data_mem_out, alu_mem_out: std_logic_vector(31 downto 0);
	signal clear_mem_out: std_logic;
	signal membus_addr_mem_out: std_logic_vector(31 downto 0);
	signal bus_rd_mem_out, bus_wr_mem_out: std_logic;
	signal cp0_rd_data_mem_out: std_logic_vector(31 downto 0);
	signal hi_mem_out, lo_mem_out: std_logic_vector(31 downto 0);
	signal block_reg_write_mem_out: std_logic;
	
	-- memwb out
	signal hi_memwb_out, lo_memwb_out: std_logic_vector(31 downto 0);
	signal pc_plus_4_memwb_out: std_logic_vector(31 downto 0);
	signal reg_write_memwb_out: std_logic;
	signal alu_memwb_out, mem_data_memwb_out: std_logic_vector(31 downto 0);
	signal reg_dst_memwb_out: std_logic_vector(4 downto 0);
	signal mem_to_reg_memwb_out: mem_to_reg_type;
	signal cp0_rd_data_memwb_out: std_logic_vector(31 downto 0);
	
	-- wb out
	signal write_data_wb_out: std_logic_vector(31 downto 0);
begin
	mmu_debug <= inst_ifid_out;
	ifid_debug <= inst_if_out;
	mux: mmu_mux port map(
		inst_bus_addr_if_out, membus_addr_mem_out,
		bus_wr_mem_out, bus_rd_mem_out,
		global_addr_mmumux_out,
		wr_mmumux_out, pc_write_mmumux_out, ifid_clear_mmumux_out
	);

	if_s: if_stage port map(
		start_addr,
		pc_plus_4_if_out, inst_if_out,
		pc_src_mem_out, pc_write_id_out, rst, clk,
		jump_pc_mem_out,
		mmu_data,
		inst_bus_addr_if_out,
		pc_write_mmumux_out,
		
		pc_debug
	);
	
	ifid_reg: ifid port map(
		pc_plus_4_if_out, inst_if_out, 
		pc_plus_4_ifid_out, inst_ifid_out,
		clk, rst, ifid_write_id_out, clear_mem_out, ifid_clear_mmumux_out, is_sb_id_out
	);
	
	id: id_stage port map(
		debug_in_addr, debug_out_data,

		inst_ifid_out, write_data_wb_out,

		reg_write_id_out, mem_read_id_out, mem_write_id_out,
		first_src_id_out,
		second_src_id_out,
		reg_dst_id_out,
		mem_to_reg_id_out,
		jump_id_out,
		alu_op_id_out,
		target_id_out,

		lo_write_id_out,
		hi_write_id_out,

		is_sb_id_out,
		cp0_write_id_out,
		tlbwi_id_out,

		rd_data1_id_out, rd_data2_id_out,
		clk, rst, mem_read_idex_out, reg_write_memwb_out,
		reg_dst_memwb_out, rt_idex_out, inst_ifid_out(25 downto 21), inst_ifid_out(20 downto 16),
		pc_write_id_out, ifid_write_id_out,
		signed_15_0_id_out, unsigned_15_0_id_out, unsigned_10_6_id_out,

		reg_write_idex_out,
		mem_to_reg_idex_out
	);
	
	idex_reg: idex port map(
		pc_plus_4_ifid_out,
		reg_dst_id_out, 
		reg_write_id_out, mem_read_id_out, mem_write_id_out, 
		mem_to_reg_id_out,
		first_src_id_out,
		second_src_id_out,
		jump_id_out,
		alu_op_id_out,
		inst_ifid_out(25 downto 21), inst_ifid_out(20 downto 16), inst_ifid_out(15 downto 11),
		rd_data1_id_out, rd_data2_id_out,
		signed_15_0_id_out, unsigned_15_0_id_out, unsigned_10_6_id_out,
		target_id_out,
		hi_write_id_out,
		lo_write_id_out,
		is_sb_id_out,
		cp0_write_id_out,
		tlbwi_id_out,
		
		clk, rst, clear_mem_out,
	
		pc_plus_4_idex_out,
		reg_dst_idex_out, 
		reg_write_idex_out, mem_read_idex_out, mem_write_idex_out, 
		mem_to_reg_idex_out,
		first_src_idex_out,
		second_src_idex_out,
		jump_idex_out,
		alu_op_idex_out,
		rs_idex_out, rt_idex_out, rd_idex_out,
		rs_data_idex_out, rt_data_idex_out,
		signed_15_0_idex_out, unsigned_15_0_idex_out, unsigned_10_6_idex_out,
		target_idex_out,
		hi_write_idex_out,
		lo_write_idex_out,
		is_sb_idex_out,
		cp0_write_idex_out,
		tlbwi_idex_out
	);
	
	exe: exe_stage port map(
		pc_plus_4_idex_out,
		branch_pc_exe_out,
		target_idex_out,
		jump_pc_exe_out,
		addr_exemem_out, write_data_wb_out, rs_data_idex_out, rt_data_idex_out, signed_15_0_idex_out, unsigned_15_0_idex_out, unsigned_10_6_idex_out,
		reg_dst_exemem_out, reg_dst_memwb_out, rs_idex_out, rt_idex_out, rd_idex_out,
		reg_write_exemem_out, reg_write_memwb_out, 
		reg_dst_idex_out,
		first_src_idex_out,
		second_src_idex_out,
		alu_op_idex_out,
		reg_dst_exe_out,
		alu_exe_out, hi_exe_out, lo_exe_out, mem_dst_exe_out, rs_data_exe_out,

		clk, rst
	);
	
	exemem_reg: exmem port map(
		clk, rst, clear_mem_out, sb_second_mem_out,

		read_data_to_exemem_mem_out, rt_data_to_exemem_mem_out,
			addr_sb_to_exemem_mem_out,
		
		pc_plus_4_idex_out,
		branch_pc_exe_out, jump_pc_exe_out,
		jump_idex_out,
		reg_write_idex_out, mem_read_idex_out, mem_write_idex_out, 
		mem_to_reg_idex_out,
		alu_exe_out, mem_dst_exe_out,
		reg_dst_exe_out,
		hi_exe_out, lo_exe_out,
		is_sb_idex_out,
		rd_idex_out,
		cp0_write_idex_out,
		tlbwi_idex_out,
		hi_write_idex_out,
		lo_write_idex_out,
		rs_data_exe_out,
		
		pc_plus_4_exemem_out,
		branch_pc_exemem_out, jump_pc_exemem_out,
		jump_exemem_out,
		reg_write_exemem_out, mem_read_exemem_out, mem_write_exemem_out, 
		mem_to_reg_exemem_out,
		addr_exemem_out, wr_data_exemem_out,
		reg_dst_exemem_out,
		hi_exemem_out, lo_exemem_out,
		is_sb_exemem_out,
		cs_exemem_out,
		cp0_write_exemem_out,
		tlbwi_exemem_out,
		hi_write_exemem_out,
		lo_write_exemem_out,
		rs_data_exemem_out
	);
	
	mem: mem_stage port map(
		branch_pc_exemem_out, jump_pc_exemem_out,
		jump_exemem_out,
		addr_exemem_out, wr_data_exemem_out,
		read_data_mem_out, alu_mem_out,
		mem_write_exemem_out, mem_read_exemem_out,
		jump_pc_mem_out,
		pc_src_mem_out, clear_mem_out,

		membus_addr_mem_out,
		mmu_data,
		bus_rd_mem_out, bus_wr_mem_out,
		write_data,

		is_sb_exemem_out,
		read_data_to_exemem_mem_out, rt_data_to_exemem_mem_out,
			addr_sb_to_exemem_mem_out,
		sb_second_mem_out,

		pc_plus_4_exemem_out,
		global_addr_mmumux_out,
		clk, rst,
		cs_exemem_out,
		cp0_rd_data_mem_out,

		cp0_write_exemem_out,
		tlbwi_exemem_out,

		tlb,

		hi_write_exemem_out,
		lo_write_exemem_out,
		rs_data_exemem_out,
		hi_mem_out, lo_mem_out,
		hi_exemem_out, lo_exemem_out,

		data_ready, tlb_missing, wr_mmumux_out,
		pc_plus_4_idex_out, pc_plus_4_ifid_out, pc_plus_4_if_out,

		cp0_data_debug,
		cp0_addr_debug,

		block_reg_write_mem_out
	);
	
	memwb_reg: memwb port map(
		clk, rst,
		
		pc_plus_4_exemem_out,
		alu_mem_out, read_data_mem_out,
		reg_dst_exemem_out,
		reg_write_exemem_out, mem_to_reg_exemem_out,
		hi_mem_out, lo_mem_out,
		cp0_rd_data_mem_out,
		
		pc_plus_4_memwb_out,
		alu_memwb_out, mem_data_memwb_out,
		reg_dst_memwb_out,
		reg_write_memwb_out, mem_to_reg_memwb_out,
		hi_memwb_out, lo_memwb_out,
		cp0_rd_data_memwb_out,

		block_reg_write_mem_out
	);
	
	wb: wb_stage port map(
		pc_plus_4_memwb_out,
		mem_to_reg_memwb_out,
		mem_data_memwb_out, alu_memwb_out, lo_memwb_out, hi_memwb_out, cp0_rd_data_memwb_out,
		write_data_wb_out
	);

	addr <= global_addr_mmumux_out;
	wr <= wr_mmumux_out;
end Behavioral;

