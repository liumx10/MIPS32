----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:41:48 11/23/2013 
-- Design Name: 
-- Module Name:    alu_mux - Behavioral 
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

entity alu_mux is
	port(
		regimm, exemem, memwb: in std_logic_vector(31 downto 0);
		output: out std_logic_vector(31 downto 0);
		sel: in alu_mux_sel
	);
end alu_mux;

architecture Behavioral of alu_mux is

begin
	output <= 
		regimm when sel = reg_imm else
		exemem when sel = exemem_ret else
		memwb;
end Behavioral;

