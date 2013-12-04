----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:36:13 11/23/2013 
-- Design Name: 
-- Module Name:    wb_stage - Behavioral 
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
use WORK.CONST.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity wb_stage is
	port(
		pc_plus_4: in std_logic_vector(31 downto 0);
		mem_to_reg: in mem_to_reg_type;
		read_data, alu_in, lo_in, hi_in, cp0_in: in std_logic_vector(31 downto 0);
		write_data: out std_logic_vector(31 downto 0)
	);
end wb_stage;

architecture Behavioral of wb_stage is

begin
	process(pc_plus_4, mem_to_reg, read_data, alu_in, lo_in, hi_in, cp0_in)
		variable temp: std_logic_vector(7 downto 0);
	begin
		if mem_to_reg = mem then
			write_data <= read_data;
		elsif mem_to_reg = mem_signed or mem_to_reg = mem_unsigned then
			if alu_in(1 downto 0) = "00" then
				temp := read_data(7 downto 0);
			elsif alu_in(1 downto 0) = "01" then
				temp := read_data(15 downto 8);
			elsif alu_in(1 downto 0) = "10" then
				temp := read_data(23 downto 16);
			else
				temp := read_data(31 downto 24);
			end if;

			if mem_to_reg = mem_signed then
				if temp(7) = '1' then
					write_data <= x"FFFFFF" & temp;
				else
					write_data <= x"000000" & temp;
				end if;
			else
				write_data <= x"000000" & temp;
			end if;
		elsif mem_to_reg = alu then
			write_data <= alu_in;
		elsif mem_to_reg = lo then
			write_data <= lo_in;
		elsif mem_to_reg = hi then
			write_data <= hi_in;
		elsif mem_to_reg = cp0 then
			write_data <= cp0_in;
		else
			write_data <= std_logic_vector(unsigned(pc_plus_4) + 4);
		end if;
	end process;
end Behavioral;

