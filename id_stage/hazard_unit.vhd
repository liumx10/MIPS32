----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:08:07 11/22/2013 
-- Design Name: 
-- Module Name:    hazard_unit - Behavioral 
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

entity hazard_unit is
	port(
		idex_memread: in std_logic;
		idex_rt, ifid_rs, ifid_rt: in std_logic_vector(4 downto 0);
		mux3_sel, pc_write, ifid_write: out std_logic;

		is_sb: in std_logic;

		idex_reg_write: in std_logic;
		idex_mem_to_reg: in mem_to_reg_type
	);
end hazard_unit;

architecture Behavioral of hazard_unit is
	signal stall: std_logic;
begin
	stall <= '1' when (idex_memread = '1' and 
		((idex_rt = ifid_rs) or (idex_rt = ifid_rt))) or is_sb = '1'
			or (idex_reg_write = '1' and 
				(idex_mem_to_reg = hi or idex_mem_to_reg = lo
					or idex_mem_to_reg = cp0)) else '0';
	pc_write <= not stall;
	ifid_write <= not stall;
	mux3_sel <= stall when is_sb = '0'
		else '0';
end Behavioral;

