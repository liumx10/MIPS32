----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:45:35 11/24/2013 
-- Design Name: 
-- Module Name:    test - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.const.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test is
    Port ( 
		clk : in  STD_LOGIC;
		rst : in  STD_LOGIC;
		clk110592: in std_logic;
		clk50: in std_logic;

		base_ram_data : inout  STD_LOGIC_vector(31 downto 0);
		base_ram_addr : out  std_logic_vector(19 downto 0);
		exp_ram_data : inout  std_logic_vector(31 downto 0);
		exp_ram_addr : out  std_logic_vector(19 downto 0);
		base_ram_en, base_ram_rw, base_ram_oe, exp_ram_en, exp_ram_rw, exp_ram_oe:out std_logic;

		data_ready: in std_logic;
		tbre, tsre: in std_logic;
		rdn, wdn:	out std_logic;

		switch: in std_logic_vector(31 downto 0);

		flash_byte, flash_ce, flash_ce1, flash_ce2, flash_oe, flash_rp, flash_vpen, flash_we:out std_logic;
		flash_data : inout  std_logic_vector(15 downto 0);
		flash_addr : out  std_logic_vector(22 downto 0);

		led: out std_logic_vector(15 downto 0)
	 );
end test; 

architecture Behavioral of test is
----------------------------------------
--component
----------------------------------------
component Mem is
	port(
	addr : in std_logic_vector(31 downto 0);
	datain: in std_logic_vector(31 downto 0);
	dataout: out std_logic_vector(31 downto 0);

	clk, rst: in std_logic;
	--clk110592: in std_logic;
	rw: in std_logic;

	tlb: in tlb_file;
	tlb_missing: out boolean;

	rom_switch: in std_logic;

	base_ram_addr, exp_ram_addr: out std_logic_vector(19 downto 0);
	base_ram_data, exp_ram_data: inout std_logic_vector(31 downto 0);
	base_ram_en, base_ram_oe, base_ram_rw: out std_logic;
	exp_ram_en, exp_ram_oe, exp_ram_rw: out std_logic;

	data_ready: in std_logic;
	tbre, tsre: in std_logic;
	rdn, wdn:	out std_logic;

	flash_addr: out std_logic_vector(22 downto 0);
	flash_data: inout std_logic_vector(15 downto 0);
	flash_byte, flash_ce, flash_ce1, flash_ce2, flash_oe, flash_rp, flash_vpen, flash_we: out std_logic
	--led:	out std_logic_vector(15 downto 0)
	);
end component;

component cpu is
	port(
		start_addr: in std_logic_vector(31 downto 0);
		debug_in_addr: in std_logic_vector(4 downto 0);
		debug_out_data: out std_logic_vector(31 downto 0);

		clk, rst: in std_logic;
		mmu_data: in std_logic_vector(31 downto 0);
		addr: out std_logic_vector(31 downto 0);
		wr: out std_logic; 
		write_data: out std_logic_vector(31 downto 0);
		tlb: out tlb_file;
		
		pc_debug: out std_logic_vector(31 downto 0);
		mmu_debug: out std_logic_vector(31 downto 0);
		ifid_debug: out std_logic_vector(31 downto 0);
		data_ready, tlb_missing: in std_logic;

		cp0_data_debug: out std_logic_vector(31 downto 0);
		cp0_addr_debug: in std_logic_vector(4 downto 0)
	);
end component;
----------------------------------------
--signal
----------------------------------------
	signal start_addr: std_logic_vector(31 downto 0);
	signal debug_in_addr: std_logic_vector(4 downto 0);
	signal debug_out_data: std_logic_vector(31 downto 0);

	signal addr, datain, dataout: std_logic_vector(31 downto 0);
	signal rw: std_logic;
	signal tlb_missing: boolean;
	signal t_missing: std_logic;
	signal tlb: tlb_file;
	
	signal state: std_logic_vector(3 downto 0);
	signal num: std_logic_vector(3 downto 0);
	
	signal rst2: std_logic;
	signal rom_switch: std_logic;
	signal cpu_clk: std_logic;
	
	signal pc_debug: std_logic_vector(31 downto 0);
	signal clk8, clk16, clk32, clk64: std_logic;
	signal clk_count: std_logic_vector(18 downto 0);
	signal if_debug: std_logic_vector(31 downto 0);
	signal ifid_debug: std_logic_vector(31 downto 0);
	
	signal cp0_data_debug: std_logic_vector(31 downto 0);
	signal cp0_addr_debug: std_logic_vector(4 downto 0);
	signal single_tlb: std_logic_vector(15 downto 0);
	
begin


----------------------------------------
--Mem
----------------------------------------
rom_switch <= not switch(31);
			
C_Mem: Mem
port map(
	addr, datain, dataout, cpu_clk, rst,  
	rw, tlb, tlb_missing, 
	rom_switch,
	
	base_ram_addr, exp_ram_addr, 
	base_ram_data, exp_ram_data,
	base_ram_en, base_ram_oe, base_ram_rw,
	exp_ram_en, exp_ram_oe, exp_ram_rw,
	
	data_ready, tbre, tsre, rdn, wdn,
	
	flash_addr, flash_data, 
	flash_byte, flash_ce, flash_ce1, flash_ce2, flash_oe, 
	flash_rp, flash_vpen, flash_we
	--led
	);

single_tlb <= '0'& tlb(CONV_INTEGER(switch(15 downto 13)))(62 downto 48) when switch(12 downto 11) = "11" else
				  tlb(CONV_INTEGER(switch(15 downto 13)))(47 downto 32) when switch(12 downto 11) = "10" else
				  tlb(CONV_INTEGER(switch(15 downto 13)))(31 downto 16) when switch(12 downto 11) = "01" else
				  tlb(CONV_INTEGER(switch(15 downto 13)))(15 downto 0) when switch(12 downto 11) = "00" ;
				  
rst2 <= not rst;
led <=     debug_out_data(31 downto 16) when switch(23 downto 20) = "0001"
		else debug_out_data(15 downto 0)  when switch(23 downto 20) = "0000"
		else cp0_data_debug(31 downto 16) when switch(23 downto 20) = "0011"
		else cp0_data_debug(15 downto 0)  when switch(23 downto 20) = "0010"
		else dataout(15 downto 0) 			 when switch(23 downto 20) = "1100"
		else dataout(31 downto 16) 		 when switch(23 downto 20) = "1101"
		else ifid_debug(31 downto 16)     when switch(23 downto 20) = "0111"
		else ifid_debug(15 downto 0) 		 when switch(23 downto 20) = "0110"
		else pc_debug(15 downto 0)        when switch(23 downto 20) = "1010"
		else pc_debug(31 downto 16)       when switch(23 downto 20) = "1011"
		else if_debug(15 downto 0)        when switch(23 downto 20) = "0110"
		else if_debug(31 downto 16)       when switch(23 downto 20) = "0111"
		else single_tlb(15 downto 0)      when switch(23 downto 21) = "111"
		else (others => '0');

start_addr <= x"80000000" when switch(29) = '1'
			else x"BFC00000";
cpu_clk <= clk when switch(30) = '1'
			else clk64 when switch(27) = '1' and switch(28) = '1'
			else clk32 when switch(27) = '1' and switch(28) = '0'
			else clk16 when switch(27) = '0' and switch(28) = '1'
			else clk8;

t_missing <= '1' when tlb_missing else '0';
debug_in_addr <= switch(4 downto 0);
cp0_addr_debug <= switch(4 downto 0);

cpu_instance: cpu 
port map(
	start_addr,
	debug_in_addr, debug_out_data,
	
	cpu_clk, rst2,
	dataout,
	addr,
	rw,
	datain,
	tlb,
	
	pc_debug,
	ifid_debug,
	if_debug,
	data_ready,
	t_missing,
	cp0_data_debug,
	cp0_addr_debug
);

clk8  <= clk_count(1);
clk16 <= clk_count(3);
clk32 <= clk_count(4);
clk64 <= clk_count(16);
 
process(clk50)
	begin	
	if rst = '0' then
		clk_count <= (others => '0');
	elsif clk50'event and clk50 = '1' then
		clk_count <= clk_count + 1;
	end if;
end process;

--process(clk, rst)
--	begin 
--	if rst = '0' then
--		addr <= x"AE000000";
--		datain <= x"00000050";
--		rw <= '1';
--	elsif clk'event and clk = '1' then
--		addr <= x"BFD003F8";
--		rw <= '0';
--		debug_out_data <= dataout;
--	end if;
--end process;
--led <= dataout(15 downto 0);
--process (clk, rst)
--begin
--	if rst = '0' then 
--		addr <= x"BE000000";
--		datain <= x"00000020";
--		state <= "0000";
--		num <= "0000";
--		rw <= '1';
--	elsif clk'event and clk = '1' then
--		case state is
--		when "0000"=>
--			rw <= '1';
--			addr <= x"BE000000";
--			datain <= x"00000020";
--			state <= "0001";
--		when "0001"=>
--			rw <= '1';
--			datain <= x"000000D0";
--			state <= "0010";
--			addr <= x"BE000000";
--		when "0010"=>			
--			rw <= '1';
--			datain <= x"00000070";
--			state <= "0011";
--			addr <= x"BE000000";
--		when "0011"=>
--			rw <= '0';
--			state <= "0101";
--			addr <= x"BE000000";
--		when "0101"=>
--			rw <= '1';
--			datain <= x"00000040";
--			addr <= x"BE000000";
--			state <= "0110";
--		when "0110" =>
--			rw <= '1';
--			datain <= x"0000F11F";
--			addr <= x"BE000000";
--			state <= "1010";
--		when "0111" =>
--			rw <= '1';
--			datain <= x"00000070";
--			addr <= x"BE000000";
--			state <= "1000";
--		when "1000" =>
--			rw <= '0';
--			state <= "1010";
--			addr <= x"BE000000";
--		when "1010" =>
--			rw <= '1';
--			addr <= x"BE000000";
--			datain <= x"000000FF";
--			state <= "1011";
--		when "1011" =>
--			rw <= '0';
--			addr <= x"BE000000";
--			state <= "1111";
--		when others=>
--			state <= "0000";
--		end case;
--	end if;
--end process;
end Behavioral;

