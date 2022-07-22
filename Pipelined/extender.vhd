--filler things

--sign extension(imm6)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign6 is
port( input: in std_logic_vector(5 downto 0);
		output: out std_logic_vector(15 downto 0));
end entity;
		
architecture behav of sign6 is
begin
output(0) <= input(0);
output(1) <= input(1);
output(2) <= input(2);
output(3) <= input(3);
output(4) <= input(4);
output(5) <= input(5);
output(6) <= '0';
output(7) <= '0';
output(8) <= '0';
output(9) <= '0';
output(10) <= '0';
output(11) <= '0';
output(12) <= '0';
output(13) <= '0';
output(14) <= '0';
output(15) <= '0';
end behav;

--sign extension(imm9).
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign9 is
port( input: in std_logic_vector(8 downto 0);
		output: out std_logic_vector(15 downto 0));
end entity;

architecture behav of sign9 is
begin
output(0) <= input(0);
output(1) <= input(1);
output(2) <= input(2);
output(3) <= input(3);
output(4) <= input(4);
output(5) <= input(5);
output(6) <= input(6);
output(7) <= input(7);
output(8) <= input(8);
output(9) <= '0';
output(10) <= '0';
output(11) <= '0';
output(12) <= '0';
output(13) <= '0';
output(14) <= '0';
output(15) <= '0';
end behav;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign9_2 is
port( input: in std_logic_vector(8 downto 0);
		output: out std_logic_vector(15 downto 0));
end entity;

architecture behav of sign9_2 is
begin
output(0) <= '0';
output(1) <= '0';
output(2) <= '0';
output(3) <= '0';
output(4) <= '0';
output(5) <= '0';
output(6) <= '0';
output(7) <= input(0);
output(8) <= input(1);
output(9) <= input(2);
output(10) <= input(3);
output(11) <= input(4);
output(12) <= input(5);
output(13) <= input(6);
output(14) <= input(7);
output(15) <= input(8);
end behav;

