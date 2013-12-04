----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:54:24 11/21/2013 
-- Design Name: 
-- Module Name:    reg32b - Behavioral 
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

entity reg32b is
	port(
		input: in std_logic_vector(31 downto 0);
		output: out std_logic_vector(31 downto 0);
		clk, reset, cs: in std_logic
	);
end reg32b;

architecture Behavioral of reg32b is

begin
	process(clk, reset) is
	begin
		if reset = '1' then
			output <= (others => '0');
		elsif clk'event and clk = '1' and cs = '1' then
			output <= input;
		end if;
	end process;
end Behavioral;

