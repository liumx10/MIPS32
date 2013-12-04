--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:44:01 11/21/2013
-- Design Name:   
-- Module Name:   E:/term5/computer/MyComputer/alu/alu_test.vhd
-- Project Name:  alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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
 
ENTITY alu_test IS
END alu_test;
 
ARCHITECTURE behavior OF alu_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
    PORT(
         input1 : IN  std_logic_vector(31 downto 0);
         input2 : IN  std_logic_vector(31 downto 0);
         code : IN  std_logic_vector(5 downto 0);
         func : IN  std_logic_vector(5 downto 0);
         output : OUT  std_logic_vector(31 downto 0);
         hi : OUT  std_logic_vector(31 downto 0);
         lo : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal input1 : std_logic_vector(31 downto 0) := (others => '0');
   signal input2 : std_logic_vector(31 downto 0) := (others => '0');
   signal code : std_logic_vector(5 downto 0) := (others => '0');
   signal func : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(31 downto 0);
   signal hi : std_logic_vector(31 downto 0);
   signal lo : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clock_period : time := 0.1 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          input1 => input1,
          input2 => input2,
          code => code,
          func => func,
          output => output,
          hi => hi,
          lo => lo
        );
 
   -- Stimulus process
   stim_proc: process
   begin		
      input1 <= x"01010101";
		input2 <= x"FFFFFFFF";
		code <= "001001";
		-- output = x"01010100"
		wait for clock_period;
		
		code <= "000000";
		func <= "100001";
		-- output = x"01010100"
		wait for clock_period;
		
		code <= "000000";
		func <= "101010";
		input1 <= x"00000000";
		input2 <= x"FFFFFFFF";
		-- output = 0
		wait for clock_period;
		
		code <= "000000";
		func <= "101011";
		-- output = 1
		wait for clock_period;
		
		code <= "000000";
		func <= "011000";
		input1 <= x"FFFFFFFF";
		input2 <= x"00000001";
		-- hi/lo = FFFFFFFFFFFFFFFF
		wait for clock_period;
		
		input1 <= x"60000000";
		input2 <= x"60000000";
		-- hi/lo
		wait for clock_period;
      wait;
   end process;

END;
