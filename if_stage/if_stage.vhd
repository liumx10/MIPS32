----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:50:15 11/22/2013 
-- Design Name: 
-- Module Name:    if_stage - Behavioral 
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

entity if_stage is
	port(
		start_addr: in std_logic_vector(31 downto 0);
		pc_plus_4, inst: out std_logic_vector(31 downto 0);
		pc_src, pc_write, reset, clk: in std_logic;
		jump_pc: in std_logic_vector(31 downto 0);
		mmu_data: in std_logic_vector(31 downto 0);
		inst_bus_addr: out std_logic_vector(31 downto 0);
		pc_write_2: in std_logic;
		pc_debug: out std_logic_vector(31 downto 0)
	);
end if_stage;

architecture Behavioral of if_stage is
	component pc_reg is
		port(
			start_addr: in std_logic_vector(31 downto 0);
			input: in std_logic_vector(31 downto 0);
			output: out std_logic_vector(31 downto 0);
			wr_en, clk, reset: in std_logic;
			wr_en_2: in std_logic;
			jump: in std_logic
		);
	end component;
	
	component mux2 is
		port(
			a, b: in std_logic_vector(31 downto 0);
			sel: in std_logic;
			output: out std_logic_vector(31 downto 0)
		);
	end component;
	
	component ins_memory is
		port(
			reset: in std_logic;
			addr: in std_logic_vector(31 downto 0);
			out_data: out std_logic_vector(31 downto 0)
		);
	end component;
	
	component adder_4 is
		port(
			x: in std_logic_vector(31 downto 0);
			y: out std_logic_vector(31 downto 0)
		);
	end component;
	
	signal pc_out, mux_out, sum_out: std_logic_vector(31 downto 0);
begin
	pc: pc_reg port map(start_addr, mux_out, pc_out, pc_write, clk, reset, pc_write_2, pc_src);
	-- im: ins_memory port map(reset, pc_out, inst);
	adder: adder_4 port map(pc_out, sum_out);
	mux: mux2 port map(sum_out, jump_pc, pc_src, mux_out);
	inst_bus_addr <= pc_out;
	inst <= mmu_data;
	pc_plus_4 <= sum_out;
	pc_debug <= pc_out;
end Behavioral;

