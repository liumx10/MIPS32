----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:33:35 11/21/2013 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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

entity alu is
	port(
		input1, input2: in std_logic_vector(31 downto 0);
		alu_op: in alu_op_type;
		output, hi, lo: out std_logic_vector(31 downto 0)
	);
end alu;

architecture Behavioral of alu is
begin
	process(input1, input2, alu_op)
		variable result: std_logic_vector(31 downto 0);
		variable mul: signed(63 downto 0);
	begin
		result := (others => '0');
		mul := (others => '0');
		case alu_op is
			when add_op =>
				result := std_logic_vector(unsigned(input1) + unsigned(input2));
			when sub_op =>
				result := std_logic_vector(unsigned(input1) - unsigned(input2));
			when lt_op =>
				if signed(input1) < signed(input2) then
					result := x"00000001";
				else
					result := x"00000000";
				end if;
			when ltu_op =>
				if unsigned(input1) < unsigned(input2) then
					result := x"00000001";
				else
					result := x"00000000";
				end if;
			when eq_op =>
				if input1 = input2 then
					result := x"00000001";
				else
					result := x"00000000";
				end if;
			when ge_op =>
				if signed(input1) >= signed(input2) then
					result := x"00000001";
				else
					result := x"00000000";
				end if;
			when gt_op =>
				if signed(input1) > signed(input2) then
					result := x"00000001";
				else
					result := x"00000000";
				end if;
			when le_op =>
				if signed(input1) <= signed(input2) then
					result := x"00000001";
				else
					result := x"00000000";
				end if;
			when neq_op =>
				if input1 /= input2 then
					result := x"00000001";
				else
					result := x"00000000";
				end if;
			when lui_op =>
				result := input2(15 downto 0) & x"0000";
			when and_op =>
				result := input1 and input2;
			when nor_op =>
				result := input1 nor input2;
			when xor_op =>
				result := input1 xor input2;
			when or_op =>
				result := input1 or input2;
			when sll_op =>
				result := to_stdlogicvector(to_bitvector(input1) sll conv_integer(input2));
			when sra_op =>
				result := to_stdlogicvector(to_bitvector(input1) sra conv_integer(input2));
			when srl_op =>
				result := to_stdlogicvector(to_bitvector(input1) srl conv_integer(input2));
			when sllv_op =>
				result := to_stdlogicvector(to_bitvector(input2) sll conv_integer(input1(4 downto 0)));
			when srav_op =>
				result := to_stdlogicvector(to_bitvector(input2) sra conv_integer(input1(4 downto 0)));
			when srlv_op =>
				result := to_stdlogicvector(to_bitvector(input2) srl conv_integer(input1(4 downto 0)));
			when mul_op =>
				mul := signed(input1) * signed(input2);
		end case;
		
		output <= result;
		hi <= std_logic_vector(mul(63 downto 32));
		lo <= std_logic_vector(mul(31 downto 0));
	end process;
end Behavioral;

