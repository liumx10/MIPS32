----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:50:03 11/27/2013 
-- Design Name: 
-- Module Name:    cp0 - Behavioral 
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
use WORK.CONST.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cp0 is
	port(
		clk, rst: in std_logic;
		syscall: in std_logic;
		eret: in std_logic;
		tlbwi: in std_logic;
		pc_plus_4: in std_logic_vector(31 downto 0);
		mem_addr: in std_logic_vector(31 downto 0);
		ebase: out std_logic_vector(31 downto 0);
		epc: out std_logic_vector(31 downto 0);

		rd_addr: in std_logic_vector(4 downto 0);
		rd_data: out std_logic_vector(31 downto 0);

		wr_en: in std_logic;
		wr_data: in std_logic_vector(31 downto 0);

		tlb_out: out tlb_file;

		data_ready, tlb_missing, rw: in std_logic;
		pc_for_next: in std_logic_vector(31 downto 0);
		exception: out std_logic;
		
		cp0_addr_debug: in std_logic_vector(4 downto 0);
		cp0_data_debug: out std_logic_vector(31 downto 0)
	);
end cp0;

architecture Behavioral of cp0 is
	type cp0_reg_type is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal cp0_reg: cp0_reg_type;
	
	signal tlb: tlb_file;
	signal intr: std_logic;
begin
	process(clk, rst)
	begin
		if rst = '1' then
			cp0_reg <= (others => (others => '0'));
			cp0_reg(15) <= x"80000000";
			tlb <= (others => (others => '0'));
		elsif clk'event and clk = '1' then
			if syscall = '1' then
				cp0_reg(14) <= pc_plus_4;
				cp0_reg(8) <= mem_addr;
				cp0_reg(13)(6 downto 2) <= "01000";
				cp0_reg(12)(1) <= '1';
			elsif eret = '1' then
				cp0_reg(12)(1) <= '0';
			elsif tlbwi = '1' then
				tlb(to_integer(unsigned(cp0_reg(0)(2 downto 0)))) <=
					cp0_reg(10)(31 downto 13) & cp0_reg(2)(25 downto 6) &
						cp0_reg(2)(1) & cp0_reg(2)(2) &
							cp0_reg(3)(25 downto 6) & cp0_reg(3)(1) & cp0_reg(3)(2);
			end if;
			if wr_en = '1' then
				cp0_reg(to_integer(unsigned(rd_addr))) <= wr_data;
				if rd_addr = "01011" then
					cp0_reg(13)(15) <= '0';
				end if;
			end if;

			--if intr = '1' then
			--	cp0_reg(14) <= pc_for_next;
			--	cp0_reg(8) <= mem_addr;
			--	cp0_reg(13)(6 downto 0) <= (others => '0');
			--	cp0_reg(12)(1) <= '1';
			--end if;
			if tlb_missing = '1' then
				cp0_reg(14) <= pc_for_next;
				cp0_reg(8) <= mem_addr;
				cp0_reg(13)(6 downto 2) <= "0001" & rw;
				cp0_reg(12)(1) <= '1';
				cp0_reg(10) <= mem_addr(31 downto 12) & "000000000000";
			end if;

			--cp0_reg(9) <= cp0_reg(9) + 1;
			--if cp0_reg(9) = cp0_reg(11) then
			--	cp0_reg(13)(15) <= '1';
			--end if;

			--cp0_reg(13)(12) <= data_ready;
		end if;
	end process;

	intr <= '1' when cp0_reg(12)(1) = '0' and cp0_reg(12)(0) = '1' and
		((cp0_reg(9) = cp0_reg(11) and cp0_reg(12)(15) = '1') or
			(data_ready = '1' and cp0_reg(12)(12) = '1')) 
	else '0';

	--exception <= intr or tlb_missing;
	exception <= tlb_missing;

	ebase <= cp0_reg(15);
	rd_data <= cp0_reg(to_integer(unsigned(rd_addr)));
	epc <= cp0_reg(14);
	tlb_out <= tlb;
	cp0_data_debug <= cp0_reg(to_integer(unsigned(cp0_addr_debug)));
end Behavioral;

