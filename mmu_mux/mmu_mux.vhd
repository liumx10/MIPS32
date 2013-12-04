----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:51:05 11/25/2013 
-- Design Name: 
-- Module Name:    mmu_mux - Behavioral 
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

entity mmu_mux is
	port(
		inst_addr, data_addr: in std_logic_vector(31 downto 0);
		wr, rd: in std_logic;
		bus_addr: out std_logic_vector(31 downto 0);
		bus_wr, pc_write, ifid_clear: out std_logic
	);
end mmu_mux;

architecture Behavioral of mmu_mux is

begin
	bus_wr <= wr;
	bus_addr <=
		inst_addr when wr = '0' and rd = '0' else
		data_addr;
	pc_write <=
		'1' when wr = '0' and rd = '0' else
		'0';
	ifid_clear <=
		'0' when wr = '0' and rd = '0' else
		'1';
end Behavioral;

