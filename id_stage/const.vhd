--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package const is
	type alu_src_type is (
		reg_2,			-- from the second register
		signed_15_0, 	-- 15:0 signed-extended
		unsigned_15_0, -- 15:0 unsigned_extended
		unsigned_10_6,	-- shift
		zero
	);
	
	type first_src_type is (
		reg_1,
		reg_2
	);
	
	type reg_dst_type is (
		rt,
		rd,
		all1
	);
	
	type mem_to_reg_type is (
		alu,
		mem,
		mem_signed,
		mem_unsigned,
		pc_plus_8,
		hi,
		lo,
		cp0
	);
	
	type alu_mux_sel is (
		reg_imm,
		exemem_ret,
		memwb_ret
	);
	
	type jump_type is (
		j,
		jr,
		b,
		syscall,
		eret,
		nop
	);
	
	type alu_op_type is(
		add_op, sub_op, and_op, or_op, xor_op, nor_op, lt_op, ltu_op, mul_op,
			sll_op, sra_op, srl_op, eq_op, ge_op, gt_op, le_op, neq_op, lui_op,
				sllv_op, srav_op, srlv_op
	);

	type hi_write_type is (
		rs,
		hi,
		nop
	);

	type lo_write_type is (
		rs,
		lo,
		nop
	);

	type tlb_file is array(0 to 7) of std_logic_vector(62 downto 0);

	constant zero_14: std_logic_vector(13 downto 0) := "00000000000000";
	constant one_14: std_logic_vector(13 downto 0) := "11111111111111";
	constant zero_2: std_logic_vector(1 downto 0) := "00";
	
--	constant reg_2 : std_logic_vector(2 downto 0) := "000";
--	constant signed_15_0 : std_logic_vector(2 downto 0) := "001";
--	constant unsigned_15_0 : std_logic_vector(2 downto 0) := "010";
--	constant unsigned_10_6 : std_logic_vector(2 downto 0) := "011";

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end const;

package body const is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end const;
