----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:07:40 11/23/2013 
-- Design Name: 
-- Module Name:    second_mux - Behavioral 
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

entity second_mux is
	port(
		reg_2_in, signed_15_0_in, unsigned_15_0_in, unsigned_10_6_in: in std_logic_vector(31 downto 0);
		output: out std_logic_vector(31 downto 0);
		sel: in alu_src_type
	);
end second_mux;

architecture Behavioral of second_mux is

begin
	output <=
		reg_2_in when sel = reg_2 else
		signed_15_0_in when sel = signed_15_0 else
		unsigned_10_6_in when sel = unsigned_10_6 else
		unsigned_15_0_in when sel = unsigned_15_0 else
		(others => '0');
end Behavioral;

