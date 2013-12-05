----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:48:43 11/22/2013 
-- Design Name: 
-- Module Name:    control - Behavioral 
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

entity control is
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
end control;

architecture Behavioral of control is
begin
	process(code, func, rt_reg, rs_reg)
		variable reg_write_v, mem_read_v, mem_write_v: std_logic;
		variable mem_to_reg_v: mem_to_reg_type;
		variable reg_dst_v: reg_dst_type;
		variable first_src_v: first_src_type;
		variable alu_src_v: alu_src_type;
		variable jump_v: jump_type;
		variable alu_op_v: alu_op_type;
		variable hi_write_v: hi_write_type;
		variable lo_write_v: lo_write_type;
		variable cp0_write_v: std_logic;
		variable tlbwi_v: std_logic;
	begin
		reg_write_v := '0';
		mem_read_v := '0';
		mem_write_v := '0';
		reg_dst_v := rd;
		mem_to_reg_v := alu;
		first_src_v := reg_1;
		alu_src_v := reg_2;
		jump_v := nop;
		alu_op_v := add_op;
		hi_write_v := nop;
		lo_write_v := nop;
		is_sb <= '0';
		cp0_write_v := '0';
		tlbwi_v := '0';
		
		case code is
			when "000000" =>
				reg_write_v := '1';
				reg_dst_v := rd;
				case func is
					when "100001" => -- addu
					when "101010" => -- slt
						alu_op_v := lt_op;
					when "101011" => -- sltu
						alu_op_v := ltu_op;
					when "100011" => -- subu
						alu_op_v := sub_op;
					when "001001" => -- jalr
						alu_src_v := zero;
						mem_to_reg_v := pc_plus_8;
						jump_v := jr;
					when "001000" => -- jr
						reg_write_v := '0';
						alu_src_v := zero;
						jump_v := jr;
					when "100100" => -- and
						alu_op_v := and_op;
					when "100111" => -- nor
						alu_op_v := nor_op;
					when "100101" => -- or
						alu_op_v := or_op;
					when "100110" => -- xor
						alu_op_v := xor_op;
					when "000000" => 
						if rt_reg = "00000" then		-- nop
							reg_write_v := '0';
						else									-- sll
							first_src_v := reg_2;
							alu_src_v := unsigned_10_6;
							alu_op_v := sll_op;
						end if;
					when "000100" => --sllv
						alu_op_v := sllv_op;
					when "000011" => -- sra
						first_src_v := reg_2;
						alu_src_v := unsigned_10_6;
						alu_op_v := sra_op;
					when "000111" => -- srav
						alu_op_v := srav_op;
					when "000010" => -- srl
						first_src_v := reg_2;
						alu_src_v := unsigned_10_6;
						alu_op_v := srl_op;
					when "000110" => -- srlv
						alu_op_v := srlv_op;
					when "011000" => -- mult
						alu_op_v := mul_op;
						reg_write_v := '0';
						lo_write_v := lo;
						hi_write_v := hi;
					when "010010" => -- mflo
						mem_to_reg_v := lo;
					when "010000" => -- mfhi
						mem_to_reg_v := hi;
					when "010011" => -- mtlo
						reg_write_v := '0';
						lo_write_v := rs;
					when "010001" => -- mthi
						reg_write_v := '0';
						hi_write_v := rs;
					when "001100" => -- syscall
						reg_write_v := '0';
						jump_v := syscall;
					when others =>
				end case;
			when "001001" => -- addiu
				reg_write_v := '1';
				reg_dst_v := rt;
				alu_src_v := signed_15_0;
			when "001010" => -- slti
				reg_write_v := '1';
				reg_dst_v := rt;
				alu_src_v := signed_15_0;
				alu_op_v := lt_op;
			when "001011" => -- sltiu
				reg_write_v := '1';
				reg_dst_v := rt;
				alu_src_v := signed_15_0;
				alu_op_v := ltu_op;
			when "000100" => -- beq
				alu_op_v := eq_op;
				jump_v := b;
			when "000001" =>
				if rt_reg = "000001" then -- bgez
					alu_op_v := ge_op;
				else						 -- bltz
					alu_op_v := lt_op;
				end if;
				alu_src_v := zero;
				jump_v := b;
			when "000111" => -- bgtz
				alu_src_v := zero;
				alu_op_v := gt_op;
				jump_v := b;
			when "000110" => -- blez
				alu_src_v := zero;
				alu_op_v := le_op;
				jump_v := b;
			when "000101" => -- bne
				alu_src_v := reg_2;
				alu_op_v := neq_op;
				jump_v := b;
			when "000010" => -- j
				jump_v := j;
			when "000011" => -- jal
				jump_v := j;
				reg_write_v := '1';
				reg_dst_v := all1;
				mem_to_reg_v := pc_plus_8;
			when "100011" => -- lw
				reg_write_v := '1';
				reg_dst_v := rt;
				mem_to_reg_v := mem;
				mem_read_v := '1';
				alu_src_v := signed_15_0;
			when "101011" => -- sw
				mem_write_v := '1';
				alu_src_v := signed_15_0;
			when "001100" => -- andi
				alu_src_v := unsigned_15_0;
				alu_op_v := and_op;
				reg_write_v := '1';
				reg_dst_v := rt;
			when "001111" => -- lui
				alu_src_v := unsigned_15_0;
				alu_op_v := lui_op;
				reg_write_v := '1';
				reg_dst_v := rt;
			when "001101" => -- ori
				alu_src_v := unsigned_15_0;
				alu_op_v := or_op;
				reg_write_v := '1';
				reg_dst_v := rt;
			when "001110" => -- xori
				alu_src_v := unsigned_15_0;
				alu_op_v := xor_op;
				reg_write_v := '1';
				reg_dst_v := rt;
			when "100000" => -- lb
				reg_write_v := '1';
				reg_dst_v := rt;
				mem_read_v := '1';
				alu_src_v := signed_15_0;
				alu_op_v := add_op;
				mem_to_reg_v := mem_signed;
			when "100100" => -- lbu
				reg_write_v := '1';
				reg_dst_v := rt;
				mem_read_v := '1';
				alu_src_v := signed_15_0;
				alu_op_v := add_op;
				mem_to_reg_v := mem_unsigned;
			when "101000" => -- sb
				is_sb <= '1';
				mem_read_v := '1';
				alu_src_v := signed_15_0;
				alu_op_v := add_op;
			when "010000" =>
				if func = "000000" or func = "000001" then
					if rs_reg = "00000" then -- mfc0
						reg_write_v := '1';
						reg_dst_v := rt;
						mem_to_reg_v := cp0;
					else -- mtc0
						cp0_write_v := '1';
					end if;
				elsif func = "011000" then -- eret
					jump_v := eret;
				else -- tlbwi
					tlbwi_v := '1';
				end if;
			when others =>
		end case;
		
		reg_write <= reg_write_v;
		mem_read <= mem_read_v;
		mem_write <= mem_write_v;
		reg_dst <= reg_dst_v;
		mem_to_reg <= mem_to_reg_v;
		first_src <= first_src_v;
		alu_src <= alu_src_v;
		jump <= jump_v;
		alu_op <= alu_op_v;
		hi_write <= hi_write_v;
		lo_write <= lo_write_v;
		cp0_write <= cp0_write_v;
		tlbwi <= tlbwi_v;
	end process;
end Behavioral;

