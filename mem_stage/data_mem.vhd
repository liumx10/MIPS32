----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:08:12 11/23/2013 
-- Design Name: 
-- Module Name:    data_mem - Behavioral 
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

entity data_mem is
	port(
		mem_write, mem_read, clk, reset: in std_logic;
		wr_data, addr: in std_logic_vector(31 downto 0);
		rd_data: out std_logic_vector(31 downto 0)
	);
end data_mem;

architecture Behavioral of data_mem is
	type memory is array(0 to 10) of std_logic_vector(31 downto 0); 
	signal mem: memory;
begin
	process(clk, reset)
	begin
		if reset = '1' then
			mem <= (others => (others => '0'));
		elsif clk'event and clk = '1' then
			if mem_write = '1' then
				mem(conv_integer(addr)) <= wr_data;
			end if;
		end if;
	end process;
	
	rd_data <= mem(conv_integer(addr));
end Behavioral;

