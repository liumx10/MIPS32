----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:04:12 11/23/2013 
-- Design Name: 
-- Module Name:    first_mux - Behavioral 
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

entity first_mux is
	port(
		rs, rt: in std_logic_vector(31 downto 0);
		output: out std_logic_vector(31 downto 0);
		first_src: in first_src_type
	);
end first_mux;

architecture Behavioral of first_mux is

begin
	output <=
		rs when first_src = reg_1 else
		rt;
end Behavioral;

