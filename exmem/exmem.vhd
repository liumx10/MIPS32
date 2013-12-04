----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:36:05 11/23/2013 
-- Design Name: 
-- Module Name:    exmem - Behavioral 
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

entity exmem is
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
end exmem;

architecture Behavioral of exmem is

begin
	process(clk, rst)
	begin
		if rst = '1' then
			reg_write <= '0';
			mem_read <= '0';
			mem_write <= '0';
			jump <= nop;
			is_sb <= '0';
			cp0_write <= '0';
			tlbwi <= '0';
			hi_write <= nop;
			lo_write <= nop;
			pc_plus_4 <= (others => '0');
		elsif clk'event and clk = '1' then
			if clear = '0' then
				if sb_second = '0' then
					reg_write <= reg_write_in;
					mem_read <= mem_read_in;
					mem_write <= mem_write_in;
					mem_to_reg <= mem_to_reg_in;
					addr <= alu_out_in;
					wr_data <= wr_data_in;
					reg_dst <= reg_dst_in;
					branch_pc <= branch_pc_in;
					jump_pc <= jump_pc_in;
					jump <= jump_in;
					pc_plus_4 <= pc_plus_4_in;
					hi <= hi_in;
					lo <= lo_in;
					is_sb <= is_sb_in;
					cs <= cs_in;
					cp0_write <= cp0_write_in;
					tlbwi <= tlbwi_in;
					hi_write <= hi_write_in;
					lo_write <= lo_write_in;
					rs_data <= rs_data_in;
				else
					wr_data <= read_data;
					if addr_sb(1 downto 0) = "00" then
						wr_data(7 downto 0) <= rt_data(7 downto 0);
					elsif addr_sb(1 downto 0) = "01" then
						wr_data(15 downto 8) <= rt_data(7 downto 0);
					elsif addr_sb(1 downto 0) = "10" then
						wr_data(23 downto 16) <= rt_data(7 downto 0);
					else
						wr_data(31 downto 24) <= rt_data(7 downto 0);
					end if;
					reg_write <= '0';
					mem_read <= '0';
					mem_write <= '1';
					addr <= addr_sb;
					jump <= nop;
					is_sb <= '0';
					cp0_write <= '0';
					tlbwi <= '0';
					hi_write <= nop;
					lo_write <= nop;
				end if;
			else
				reg_write <= '0';
				mem_read <= '0';
				mem_write <= '0';
				jump <= nop;
				is_sb <= '0';
				cp0_write <= '0';
				tlbwi <= '0';
				hi_write <= nop;
				lo_write <= nop;
				pc_plus_4 <= (others => '0');
			end if;
		end if;
	end process;
end Behavioral;

