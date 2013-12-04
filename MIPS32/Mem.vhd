library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.Const.all;


entity Mem is 

port(
	addr : in std_logic_vector(31 downto 0);
	datain: in std_logic_vector(31 downto 0);
	dataout: out std_logic_vector(31 downto 0);

	clk, rst: in std_logic;
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
end Mem;

architecture Behavioral of Mem is

-----------------------------------------
--component
-----------------------------------------
component tlbfile is
port(
	tlb: in tlb_file;
	addr: in std_logic_vector(31 downto 0);
	tlb_missing: out boolean;
	actual_addr: out std_logic_vector(31 downto 0)
	);
end component;

component bootloader is 
port (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;

component flashprogrammer is
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;

------------------------
--signal 
------------------------

signal actual_addr : std_logic_vector(31 downto 0);
signal missing: boolean;

signal bootloader_addr: std_logic_vector(9 downto 0);
signal bootloader_data: std_logic_vector(31 downto 0);
signal rom_data: std_logic_vector(31 downto 0);
signal flashpro_addr:std_logic_vector(9 downto 0);
signal flashpro_data: std_logic_vector(31 downto 0);

signal tmp: std_logic_vector(1 downto 0);

signal port1_en, port2_en, ram1_en, ram2_en, flash_en, rom_en, vga_en: boolean;
signal last_port1, last_port2, last_ram1, last_ram2, last_rom, last_flash: boolean;

signal port_data	: std_logic_vector(31 downto 0);
signal clka:std_logic;
begin 
--	rst2 <= not rst;
	clka <= not clk;
	tlb1: tlbfile 
		port map( tlb => tlb, addr=>addr, tlb_missing => missing, actual_addr => actual_addr);
	bloader: bootloader
		port map( clka => clka, addra => bootloader_addr, douta=> bootloader_data );
	fprogrammer: flashprogrammer
		port map( clka => clka, addra => flashpro_addr, douta => flashpro_data);
	
	flash_ce<='0';
	flash_ce1<='0';
	flash_ce2<='0';
	flash_rp<='1';
	flash_byte<='1';
	flash_vpen<='1';	
	
	tlb_missing <= missing;
 
	rom_en <= actual_addr(31 downto 12) = x"1FC00";
	flash_en <= actual_addr(31 downto 24) = x"1E";
	port1_en <= actual_addr = x"1FD003F8";
	port2_en <= actual_addr = x"1FD003FC";

	ram1_en <= not missing and not rom_en and not flash_en and not port1_en and not port2_en and not vga_en and actual_addr(22) = '0';
	ram2_en <= not missing and not rom_en and not flash_en and not port1_en and not port2_en and not vga_en and actual_addr(22) = '1';
	vga_en  <= actual_addr = x"1FC03000";

	rom_data <= bootloader_data when rom_switch = '1'
					else flashpro_data;
	
	tmp(1) <= '1' when data_ready = '1' else '0';
	tmp(0) <= '1' when tbre = '1' and tsre = '1' else  '0';
	
	port_data <= x"000000"& base_ram_data(7 downto 0) when port1_en
			else x"0000000" & "00" & tmp 			  ;			
				
	dataout <=   base_ram_data					when last_ram1
			else (others => '1')				when vga_en
			else exp_ram_data					when last_ram2
			else x"0000" & flash_data 			when last_flash
			else x"000000" & base_ram_data(7 downto 0) 		when last_port1
			else x"0000000" & "00" & tmp		when last_port2 
			else rom_data						when last_rom   
			else (others => '0');
 
	wdn <= '0'  when clk = '0' and rw = '1' and port1_en 
			else '1';
	rdn <= '0'  when clk = '0' and rw = '0' and port1_en
			else '1';

	base_ram_rw <= '0' when clk = '0' and rw = '1' and ram1_en
					else '1';
	base_ram_oe <= '0' when clk = '0' and rw = '0' and ram1_en
					else '1';
	base_ram_en <= '0' when ram1_en and not port1_en
					else '1';

	exp_ram_rw <= '0' when clk = '0' and rw = '1' and ram2_en
					else '1';
	exp_ram_oe <= '0' when clk = '0' and rw = '0' and ram2_en
					else '1';
	exp_ram_en <= '0' when ram2_en
					else '0';

	flash_oe <= '0' when clk = '0' and rw = '0' and flash_en
					else '1'; 
	flash_we <= '0' when clk = '0' and rw = '1' and flash_en
					else '1';

	base_ram_data <= x"000000" & datain(7 downto 0) when rw = '1' and port1_en
			else  (others =>'Z')  when rw = '0' 
			else  datain when rw = '1' and ram1_en;

	base_ram_addr <= actual_addr(21 downto 2);
	
	bootloader_addr <= actual_addr(11 downto 2);
	flashpro_addr <= actual_addr(11 downto 2);
process (clk, rst)
	begin
	if rst = '0' then
		last_port1 <= false;
		last_port2 <= false;
		last_ram1 <= false;
		last_ram2 <= false;
		last_flash <= false;
		last_rom <= false;
	elsif clk'event and clk = '0' then
		if port1_en then
--			if rw = '0' then
--				base_ram_data<= (others => 'Z');
--			else 
--				base_ram_data <= datain;
--			end if;
		elsif port2_en then
			
		elsif flash_en then -- flash
			if rw = '0' then
				flash_addr <= actual_addr(23 downto 1);
				flash_data <= (others=> 'Z');
			else
				flash_addr <= actual_addr(23 downto 1);
				flash_data <= datain(15 downto 0);
			end if;

		elsif rom_en then -- rom
		elsif not missing then
			if ram1_en then
				if rw = '0' then          --read
					--base_ram_addr <= actual_addr(21 downto 2);
					--base_ram_data <= (others => 'Z');
				else
					--base_ram_addr <= actual_addr(21 downto 2);
					--base_ram_data <= datain;
				end if;
			elsif ram2_en then
				if rw = '0' then 
					exp_ram_addr <= addr(21 downto 2);
					exp_ram_data <= (others => 'Z');	
				else
					exp_ram_addr <= addr(21 downto 2);
					exp_ram_data <= datain;
				end if;
			end if;
		end if;
		last_port1 <= port1_en;
		last_port2 <= port2_en;
		last_ram1 <= ram1_en;
		last_ram2 <= ram2_en;
		last_flash <= flash_en;
		last_rom <= rom_en;

	end if;
end process;
end Behavioral;