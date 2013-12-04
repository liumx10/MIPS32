----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:15:03 11/26/2013 
-- Design Name: 
-- Module Name:    lo_reg - Behavioral 
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

entity lo_reg is
	port(
		lo_write: in lo_write_type;
		rs_in, lo_in: in std_logic_vector(31 downto 0);
		lo_out: out std_logic_vector(31 downto 0);
		clk, rst: in std_logic
	);
end lo_reg;

architecture Behavioral of lo_reg is

begin
	process(clk, rst)
	begin
		if rst = '1' then
			lo_out <= (others => '0');
		elsif clk'event and clk = '1' then
			if lo_write = rs then
				lo_out <= rs_in;
			elsif lo_write = lo then
				lo_out <= lo_in;
			end if;
		end if;
	end process;
end Behavioral;

