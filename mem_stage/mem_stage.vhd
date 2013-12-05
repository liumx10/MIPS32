----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:14:28 11/23/2013 
-- Design Name: 
-- Module Name:    mem_stage - Behavioral 
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

use WORK.CONST.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem_stage is
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
		cp0_addr_debug: in std_logic_vector(4 downto 0)
	);
end mem_stage;

architecture Behavioral of mem_stage is
	component branch is
		port(
			branch_pc, jump_pc, alu: in std_logic_vector(31 downto 0);
			jump: in jump_type;
			next_pc: out std_logic_vector(31 downto 0);
			pc_sel, clear: out std_logic;

			epc: in std_logic_vector(31 downto 0);
			ebase: in std_logic_vector(31 downto 0);
			syscall_out: out std_logic;
			eret_out: out std_logic;

			exception: in std_logic;
			jump_or_not: out std_logic;
			dest_pc: out std_logic_vector(31 downto 0)
		);
	end component;

	component cp0 is
		port(
			clk, rst: in std_logic;
			syscall: in std_logic;
			eret: in std_logic;
			tlbwi: in std_logic;
			pc_plus_4: in std_logic_vector(31 downto 0);
			mem_addr: in std_logic_vector(31 downto 0);
			ebase: out std_logic_vector(31 downto 0);
			epc: out std_logic_vector(31 downto 0);

			rd_addr: in std_logic_vector(4 downto 0);
			rd_data: out std_logic_vector(31 downto 0);

			wr_en: in std_logic;
			wr_data: in std_logic_vector(31 downto 0);

			tlb_out: out tlb_file;

			data_ready, tlb_missing, rw: in std_logic;
			pc_for_next: in std_logic_vector(31 downto 0);
			exception: out std_logic;
		
			cp0_addr_debug: in std_logic_vector(4 downto 0);
			cp0_data_debug: out std_logic_vector(31 downto 0);

			is_sb: in std_logic
		);
	end component;

	component hi_reg is
		port(
			hi_write: in hi_write_type;
			rs_in, hi_in: in std_logic_vector(31 downto 0);
			hi_out: out std_logic_vector(31 downto 0);
			clk, rst: in std_logic
		);
	end component;

	component lo_reg is
		port(
			lo_write: in lo_write_type;
			rs_in, lo_in: in std_logic_vector(31 downto 0);
			lo_out: out std_logic_vector(31 downto 0);
			clk, rst: in std_logic
		);
	end component;

	signal syscall_branch_out: std_logic;
	signal eret_branch_out: std_logic;
	signal ebase_cp0_out: std_logic_vector(31 downto 0);
	signal epc_cp0_out: std_logic_vector(31 downto 0);
	signal exception: std_logic;
	signal pc_for_next_sig: std_logic_vector(31 downto 0);
	signal jump_or_not: std_logic;
	signal dest_pc_sig: std_logic_vector(31 downto 0);
begin
	hi_reg_instance: hi_reg port map(
		hi_write,
		rs_data, alu_hi,
		hi_out,
		clk, rst
	);

	lo_reg_instance: lo_reg port map(
		lo_write,
		rs_data, alu_lo,
		lo_out,
		clk, rst
	);

	b: branch port map(
		branch_pc_in, jump_pc_in, alu_in,
		jump,
		next_pc,
		pc_sel, clear,

		epc_cp0_out,
		ebase_cp0_out,
		syscall_branch_out,
		eret_branch_out,

		exception,
		jump_or_not,
		dest_pc_sig
	);

	cp0_reg: cp0 port map(
		clk, rst,
		syscall_branch_out,
		eret_branch_out,
		tlbwi,
		pc_plus_4_in,
		global_bus_addr,
		ebase_cp0_out,
		epc_cp0_out,

		cp0_rd_addr,
		cp0_rd_data,

		cp0_write,
		write_data,

		tlb_out,

		data_ready, tlb_missing, rw,
		pc_for_next_sig,
		exception,

		cp0_addr_debug,
		cp0_data_debug,

		is_sb
	);

	read_data <= mmu_data;
	mem_bus_addr <= alu_in;
	bus_rd <= mem_read;
	bus_wr <= mem_write;

	write_data_out <= write_data;
	
	alu_out <= alu_in;

	read_data_to_exmem <= mmu_data;
	rt_data_to_exmem <= write_data;
	addr_sb_to_exmem <= alu_in;
	sb_second <= is_sb;

	pc_for_next_sig <= dest_pc_sig when jump_or_not = '1' else
		pc_plus_4_in - 4 when (mem_write = '1' or mem_read = '1') and tlb_missing = '1' else
		pc_plus_4_idex_out - 4 when pc_plus_4_idex_out /= x"00000000" else
		pc_plus_4_ifid_out - 4 when pc_plus_4_ifid_out /= x"00000000" else
		pc_plus_4_if_out - 4;

end Behavioral;

