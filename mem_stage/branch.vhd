----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:08:48 11/24/2013 
-- Design Name: 
-- Module Name:    branch - Behavioral 
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

entity branch is
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
end branch;

architecture Behavioral of branch is

begin
	process(branch_pc, jump_pc, alu, jump, ebase, epc, exception)
		variable branch: std_logic;
	begin
		next_pc <= (others => '0');
		syscall_out <= '0';
		eret_out <= '0';
		case jump is
			when j =>
				next_pc <= jump_pc;
				dest_pc <= jump_pc;
				branch := '1';
			when jr =>
				next_pc <= alu;
				dest_pc <= alu;
				branch := '1';
			when b =>
				if alu = x"00000001" then
					next_pc <= branch_pc;
					dest_pc <= branch_pc;
					branch := '1';
				else
					branch := '0';
				end if;
			when syscall =>
				next_pc <= ebase + 384;
				dest_pc <= ebase + 384;
				branch := '1';
				syscall_out <= '1';
			when eret =>
				next_pc <= epc;
				dest_pc <= epc;
				branch := '1';
				eret_out <= '1';
			when others =>
				branch := '0';
		end case;
		
		clear <= branch;
		pc_sel <= branch;
		jump_or_not <= branch;

		if exception = '1' then
			clear <= '1';
			pc_sel <= '1';
			next_pc <= ebase + 384;
		end if;
	end process;
end Behavioral;

