library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers is 
	port(
			 rf_a1,rf_a2,rf_a3   : in std_logic_vector(2 DOWNTO 0);
			 rst : in std_logic; -- async. clear.
			 clk : in std_logic; -- clock.
			 wr  : in std_logic; -- write
			 rf_d3 : in std_logic_vector(15 downto 0);
			 rf_d1,rf_d2,R7  : out std_logic_vector(15 DOWNTO 0)); -- output
end entity;

architecture struct of registers is

component single_reg is 
		port(	input_reg: in std_logic_vector(15 downto 0);
		output: out std_logic_vector(15 downto 0);
		en: in std_logic;
		clk,rst: in std_logic);
end component;

type registerFile is array(0 to 7) of std_logic_vector(15 downto 0);
signal registers : registerFile;
type bitarr is array(0 to 7) of std_logic;
signal wrarr2 : bitarr := "00000000";
signal wrarr1 : bitarr := "00000000";
signal temp1,temp2 : std_logic_vector(15 downto 0);

begin

inst_reg : for i in 0 to 7 generate
R0: single_reg port map (input_reg => rf_d3, output => registers(i), en => wrarr1(i), rst => rst, clk => clk);
end generate inst_reg;

 
reg_file : process (clk, rst, wr)
	begin	
		
		if wr = '1' then
			wrarr1 <= (others => '0');
			wrarr1(to_integer(unsigned(rf_a3))) <= '1';
			temp1 <= (others => '0');
			temp2 <= (others => '0');
		
		else 
			temp1 <= registers(to_integer(unsigned(rf_a1)));
			temp2 <= registers(to_integer(unsigned(rf_a2)));
			wrarr1 <= (others => '0');
			
		end if;
		
	end process reg_file;
		
		rf_d1 <= temp1;
		rf_d2 <= temp2;
		R7 <= registers(7);
		
end struct;