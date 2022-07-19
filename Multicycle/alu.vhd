library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
port( in1, in2: in std_logic_vector(15 downto 0);
		alu_out: out std_logic_vector(15 downto 0);
		carry: out std_logic;
		zero: out std_logic;
		alu_sel1: in std_logic;
		alu_sel2: in std_logic); --add and nand and xor
end entity;

architecture behav of alu is
signal temp :std_logic_vector(15 downto 0);
signal temp1 :unsigned(std_logic_vector(15 downto 0));
begin
process(in1, in2, alu_sel1, alu_sel2)
begin
if(alu_sel1 = '1' and alu_sel2 = '0') then  --add
	if(in1 = "0000000000000000" and in2 = "0000000000000000") then
		zero <= '1';
		temp <= "0000000000000000";
	elsif(in1(15) = '1' and in2(15) = '1') then
		carry <= '1';
		temp <= std_logic_vector(unsigned(in1) + unsigned(in2));
	else
		carry <= '0';
		temp <= std_logic_vector(unsigned(in1) + unsigned(in2));
	end if;
elsif(alu_sel1 = '0' and alu_sel2 = '0') then  --nand
	temp <= in1 nand in2;
	if(temp = "0000000000000000") then
		zero <= '1';
	end if;
elsif(alu_sel1 = '1' and alu_sel2 = '1') then --equality
	temp <= in1 xor in2;
	if(temp = "0000000000000000") then
		zero <= '1';
	end if;
elsif(alu_sel1 = '0' and alu_sel2 = '1') then 
		temp1<=shift_left(unsigned(in2), to_integer(1));
		temp<=std_logic_vector(unsigned(in1) + unsigned(temp1));
end if;
end process;
alu_out <= temp;
end behav;
	

