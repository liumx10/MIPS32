----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:18:41 11/21/2013 
-- Design Name: 
-- Module Name:    ins_memory - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ins_memory is
	port(
		reset: in std_logic;
		addr: in std_logic_vector(31 downto 0);
		out_data: out std_logic_vector(31 downto 0)
	);
end ins_memory;

architecture Behavioral of ins_memory is
	type memory_type is array(0 to 10) of std_logic_vector(31 downto 0);
	signal memory: memory_type;
begin
	process(reset) is
	begin
		if reset = '1' then
			memory <= (others => (others => '0'));
			memory(0) <= x"00000001";
			memory(4) <= x"00000002";
			memory(8) <= x"00000003";
		end if;
	end process;
	
	out_data <= memory(conv_integer(addr));
end Behavioral;

