----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:39:35 11/23/2013 
-- Design Name: 
-- Module Name:    ifid - Behavioral 
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

entity ifid is
	port(
		pc_plus_4_in, inst_in: in std_logic_vector(31 downto 0);
		pc_plus_4_out, inst_out: out std_logic_vector(31 downto 0);
		clk, reset, wr_en, clear, clear_2, is_sb_id_out: in std_logic
	);
end ifid;
-- clear = 1: branch
-- clear_2 = 1: bus busy
-- write = 0: mem_read = 1 for the previous instruction.

architecture Behavioral of ifid is

begin
	process(clk, reset) 
	begin
		if reset = '1' then
			pc_plus_4_out <= (others => '0');
			inst_out <= (others => '0');
		elsif clk'event and clk = '1' then
			if clear = '1' then
				pc_plus_4_out <= (others => '0');
				inst_out <= (others => '0');
			elsif wr_en = '0' then
				if is_sb_id_out = '1' then
					pc_plus_4_out <= (others => '0');
					inst_out <= (others => '0');
				end if;
			elsif clear_2 = '1' then
				pc_plus_4_out <= (others => '0');
				inst_out <= (others => '0');
			else
				pc_plus_4_out <= pc_plus_4_in;
				inst_out <= inst_in;
			end if;
		end if;
	end process;
end Behavioral;

