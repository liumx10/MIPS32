----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:59:47 11/23/2013 
-- Design Name: 
-- Module Name:    memwb - Behavioral 
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

entity memwb is
	port(
		clk, rst: in std_logic;
		
		pc_plus_4_in: in std_logic_vector(31 downto 0);
		alu_ret_in, mem_data_in: in std_logic_vector(31 downto 0);
		reg_dst_in: in std_logic_vector(4 downto 0);
		reg_write_in: in std_logic;
		mem_to_reg_in: in mem_to_reg_type;
		hi_in, lo_in: in std_logic_vector(31 downto 0);
		cp0_data_in: in std_logic_vector(31 downto 0);
		
		pc_plus_4: out std_logic_vector(31 downto 0);
		alu_ret, mem_data: out std_logic_vector(31 downto 0);
		reg_dst: out std_logic_vector(4 downto 0);
		reg_write: out std_logic;
		mem_to_reg: out mem_to_reg_type;
		hi, lo: out std_logic_vector(31 downto 0);
		cp0_data: out std_logic_vector(31 downto 0)
	);
end memwb;

architecture Behavioral of memwb is

begin
	process(clk, rst)
	begin
		if rst = '1' then
			alu_ret <= (others => '0');
			mem_data <= (others => '0');
			reg_dst <= (others => '0');
			reg_write <= '0';
			mem_to_reg <= alu;
			pc_plus_4 <= (others => '0');
			hi <= (others => '0');
			lo <= (others => '0');
			cp0_data <= (others => '0');
		elsif clk'event and clk = '1' then
			alu_ret <= alu_ret_in;
			mem_data <= mem_data_in;
			reg_dst <= reg_dst_in;
			reg_write <= reg_write_in;
			mem_to_reg <= mem_to_reg_in;
			pc_plus_4 <= pc_plus_4_in;
			hi <= hi_in;
			lo <= lo_in;
			cp0_data <= cp0_data_in;
		end if;
	end process;
end Behavioral;

