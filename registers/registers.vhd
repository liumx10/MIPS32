----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:42:28 11/21/2013 
-- Design Name: 
-- Module Name:    registers - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registers is
	port(
		debug_in_addr: in std_logic_vector(4 downto 0);
		debug_out_data: out std_logic_vector(31 downto 0);

		clk, reset, wr_en: in std_logic;
		wr_addr, rd_addr1, rd_addr2: in std_logic_vector(4 downto 0);
		wr_data: in std_logic_vector(31 downto 0);
		rd_data1, rd_data2: out std_logic_vector(31 downto 0)
	);
end registers;

architecture Behavioral of registers is
	type reg_file is array(31 downto 0) of std_logic_vector(31 downto 0);
	signal reg: reg_file;

begin
	process(clk, reset)
	begin
		if reset = '1' then
			reg <= (others => (others => '0'));
		elsif clk'event and clk = '0' then
			if wr_en = '1' and wr_addr /= "00000" then
				reg(to_integer(unsigned(wr_addr))) <= wr_data;
			end if;
		end if;
	end process;
	
	rd_data1 <= reg(to_integer(unsigned(rd_addr1)));
	rd_data2 <= reg(to_integer(unsigned(rd_addr2)));

	debug_out_data <= reg(to_integer(unsigned(debug_in_addr)));
end Behavioral;

