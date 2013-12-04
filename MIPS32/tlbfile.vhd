library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.Const.all;

entity tlbfile is
port(
	tlb: in tlb_file;
	addr: in std_logic_vector(31 downto 0);
	tlb_missing: out boolean;
	actual_addr: out std_logic_vector(31 downto 0)
	);
end tlbfile;
 
architecture Behavioral of tlbfile is

signal use_mmu: boolean;
signal page_index: std_logic_vector(3 downto 0);

begin
	use_mmu <= Addr(31 downto 29) /="100" and Addr(31 downto 29)/="101";
	page_index<="0000" when Tlb(0)(62 downto 44)=Addr(31 downto 13) and ((Addr(12)='0' and Tlb(0)(23)='1') or (Addr(12)='1' and  Tlb(0)(1)='1'))else
					"0001" when Tlb(1)(62 downto 44)=Addr(31 downto 13) and ((Addr(12)='0' and Tlb(1)(23)='1') or (Addr(12)='1' and  Tlb(1)(1)='1'))else
					"0010" when Tlb(2)(62 downto 44)=Addr(31 downto 13) and ((Addr(12)='0' and Tlb(2)(23)='1') or (Addr(12)='1' and  Tlb(2)(1)='1'))else
					"0011" when Tlb(3)(62 downto 44)=Addr(31 downto 13) and ((Addr(12)='0' and Tlb(3)(23)='1') or (Addr(12)='1' and  Tlb(3)(1)='1'))else
					"0100" when Tlb(4)(62 downto 44)=Addr(31 downto 13) and ((Addr(12)='0' and Tlb(4)(23)='1') or (Addr(12)='1' and  Tlb(4)(1)='1'))else
					"0101" when Tlb(5)(62 downto 44)=Addr(31 downto 13) and ((Addr(12)='0' and Tlb(5)(23)='1') or (Addr(12)='1' and  Tlb(5)(1)='1'))else
					"0110" when Tlb(6)(62 downto 44)=Addr(31 downto 13) and ((Addr(12)='0' and Tlb(6)(23)='1') or (Addr(12)='1' and  Tlb(6)(1)='1'))else
					"0111" when Tlb(7)(62 downto 44)=Addr(31 downto 13) and ((Addr(12)='0' and Tlb(7)(23)='1') or (Addr(12)='1' and  Tlb(7)(1)='1'))else
					"1000";
	actual_addr<= "000" & Addr(28 downto 0) 
							when not use_mmu
						else Tlb(CONV_INTEGER(page_index))(43 downto 24)&Addr(11 downto 0)
							when page_index/="1000" and Addr(12)='0'
						else Tlb(CONV_INTEGER(page_index))(21 downto 2)&Addr(11 downto 0)
							when page_index/="1000" and Addr(12)='1'
						else x"FFFFFFF0";
						
	tlb_missing<= use_mmu and page_index="1000";
--	actual_addr <= "000" & Addr(28 downto 0);
--	tlb_missing <= false;

end Behavioral;

