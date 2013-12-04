----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:11:52 11/23/2013 
-- Design Name: 
-- Module Name:    reg_dst_mux - Behavioral 
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

entity reg_dst_mux is
	port(
		rt_reg, rd_reg: in std_logic_vector(4 downto 0);
		output: out std_logic_vector(4 downto 0);
		sel: in reg_dst_type
	);
end reg_dst_mux;

architecture Behavioral of reg_dst_mux is

begin
	output <=
		rt_reg when sel = rt else
		rd_reg when sel = rd else
		"11111";
end Behavioral;

