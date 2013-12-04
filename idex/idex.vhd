----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:09:07 11/23/2013 
-- Design Name: 
-- Module Name:    idex - Behavioral 
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

use WORK.CONST.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity idex is
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
end idex;

architecture Behavioral of idex is

begin
	process (clk, rst)
	begin
		if rst = '1' then
			reg_write <= '0';
			mem_read <= '0';
			mem_write <= '0';
			jump <= nop;
			hi_write <= nop;
			lo_write <= nop;
			is_sb <= '0';
			cp0_write <= '0';
			tlbwi <= '0';
			pc_plus_4 <= (others => '0');
		elsif clk'event and clk = '1' then
			if clear = '0' then
				pc_plus_4 <= pc_plus_4_in;
				reg_dst <= reg_dst_in;
				reg_write <= reg_write_in;
				mem_read <= mem_read_in;
				mem_write <= mem_write_in;
				mem_to_reg <= mem_to_reg_in;
				jump <= jump_in;
				alu_op <= alu_op_in;
				first_src <= first_src_in;
				second_src <= second_src_in;
				rs <= rs_in;
				rt <= rt_in;
				rd <= rd_in;
				rs_data <= rs_data_in;
				rt_data <= rt_data_in;
				signed_15_0 <= signed_15_0_in;
				unsigned_15_0 <= unsigned_15_0_in;
				unsigned_10_6 <= unsigned_10_6_in;
				target <= target_in;
				hi_write <= hi_write_in;
				lo_write <= lo_write_in;
				is_sb <= is_sb_in;
				cp0_write <= cp0_write_in;
				tlbwi <= tlbwi_in;
			else
				reg_write <= '0';
				mem_read <= '0';
				mem_write <= '0';
				jump <= nop;
				hi_write <= nop;
				lo_write <= nop;
				is_sb <= '0';
				cp0_write <= '0';
				tlbwi <= '0';
				pc_plus_4 <= (others => '0');
			end if;
		end if;
	end process;
end Behavioral;

