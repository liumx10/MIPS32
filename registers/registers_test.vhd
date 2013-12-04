--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:22:29 11/21/2013
-- Design Name:   
-- Module Name:   E:/term5/computer/MyComputer/registers/registers_test.vhd
-- Project Name:  registers
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: registers
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY registers_test IS
END registers_test;
 
ARCHITECTURE behavior OF registers_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT registers
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         wr_en : IN  std_logic;
         wr_addr : IN  std_logic_vector(4 downto 0);
         rd_addr1 : IN  std_logic_vector(4 downto 0);
         rd_addr2 : IN  std_logic_vector(4 downto 0);
         wr_data : IN  std_logic_vector(31 downto 0);
         rd_data1 : OUT  std_logic_vector(31 downto 0);
         rd_data2 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal wr_en : std_logic := '0';
   signal wr_addr : std_logic_vector(4 downto 0) := (others => '0');
   signal rd_addr1 : std_logic_vector(4 downto 0) := (others => '0');
   signal rd_addr2 : std_logic_vector(4 downto 0) := (others => '0');
   signal wr_data : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal rd_data1 : std_logic_vector(31 downto 0);
   signal rd_data2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 0.1us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: registers PORT MAP (
          clk => clk,
          reset => reset,
          wr_en => wr_en,
          wr_addr => wr_addr,
          rd_addr1 => rd_addr1,
          rd_addr2 => rd_addr2,
          wr_data => wr_data,
          rd_data1 => rd_data1,
          rd_data2 => rd_data2
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for clk_period;	
		
		reset <= '0';

      -- insert stimulus here 
		rd_addr1 <= "11111";
		rd_addr2 <= "11110";
		wr_en <= '1';
		wr_addr <= "11111";
		wr_data <= x"FFFFFFFF";
		
		wait for clk_period;
		
		wr_data <= x"00000000";
		
		wait for clk_period;
		
		wr_en <= '0';
		wr_data <= x"FFFFFFFF";
		
		wait for clk_period;
		
		wr_en <= '1';
		wr_addr <= "11110";
		wr_data <= x"FFFFFFFF";

      wait;
   end process;

END;
