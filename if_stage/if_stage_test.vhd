--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:10:33 11/22/2013
-- Design Name:   
-- Module Name:   E:/term5/computer/MyComputer/if_stage/if_stage_test.vhd
-- Project Name:  if_stage
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: if_stage
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
 
ENTITY if_stage_test IS
END if_stage_test;
 
ARCHITECTURE behavior OF if_stage_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT if_stage
    PORT(
         next_pc : OUT  std_logic_vector(31 downto 0);
         inst : OUT  std_logic_vector(31 downto 0);
         haz_ret : IN  std_logic;
         pc_cs : IN  std_logic;
         reset : IN  std_logic;
         clk : IN  std_logic;
         alu_ret : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal haz_ret : std_logic := '0';
   signal pc_cs : std_logic := '0';
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal alu_ret : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal next_pc : std_logic_vector(31 downto 0);
   signal inst : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 0.1 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: if_stage PORT MAP (
          next_pc => next_pc,
          inst => inst,
          haz_ret => haz_ret,
          pc_cs => pc_cs,
          reset => reset,
          clk => clk,
          alu_ret => alu_ret
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
      reset <= '1';
		wait for clk_period;
		
		pc_cs <= '1';
		reset <= '0';
		haz_ret <= '0';
		wait for clk_period;
		
		wait for clk_period;
		
		wait for clk_period;
		
      wait;
   end process;

END;
