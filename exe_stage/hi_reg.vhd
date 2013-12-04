----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:11:18 11/26/2013 
-- Design Name: 
-- Module Name:    hi_reg - Behavioral 
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

entity hi_reg is
	port(
		hi_write: in hi_write_type;
		rs_in, hi_in: in std_logic_vector(31 downto 0);
		hi_out: out std_logic_vector(31 downto 0);
		clk, rst: in std_logic
	);
end hi_reg;

architecture Behavioral of hi_reg is

begin
	process(clk, rst)
	begin
		if rst = '1' then
			hi_out <= (others => '0');
		elsif clk'event and clk = '1' then
			if hi_write = rs then
				hi_out <= rs_in;
			elsif hi_write = hi then
				hi_out <= hi_in;
			end if;
		end if;
	end process;
end Behavioral;

