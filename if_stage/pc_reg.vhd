----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:45:22 11/22/2013 
-- Design Name: 
-- Module Name:    pc_reg - Behavioral 
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

entity pc_reg is
	port(
		start_addr: in std_logic_vector(31 downto 0);
		input: in std_logic_vector(31 downto 0);
		output: out std_logic_vector(31 downto 0);
		wr_en, clk, reset: in std_logic;
		wr_en_2: in std_logic;
		jump: in std_logic
	);
end pc_reg;

-- wr_en = 1 : stall in id
-- wr_en_2 = 1 : stall in mmumux
-- jump = 1: jump in MEM

architecture Behavioral of pc_reg is
	signal is_alive: std_logic;
begin
	process(clk, reset)
	begin
		if reset = '1' then
			output <=  start_addr;
			is_alive <= '0';
		elsif clk'event and clk = '1' then
			if is_alive = '0' then
				is_alive <= '1';
			elsif jump = '1' then
				output <= input;
			elsif wr_en = '1' and wr_en_2 = '1' then
				output <= input;
			end if;
		end if;
	end process;
end Behavioral;

