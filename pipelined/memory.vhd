library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

library ieee;
use ieee.numeric_std.all; 

entity memory is
		port(wr: in std_logic;
			 rd: in std_logic;
			 init: in std_logic;
			 data: in std_logic_vector(15 downto 0);
			 addr: in std_logic_vector(15 downto 0);
			 outp: out std_logic_vector(15 downto 0));
end entity;

architecture am of memory is
		type marray is array (0 to 15) of std_logic_vector(15 downto 0);
		signal mbank: marray;
		begin
		process(wr, rd, init, mbank, data, addr)
			begin
			if (init = '1') then
				for i in 0 to 15 loop
					mbank(i) <= "1111111111111111";
				end loop;
			end if;
		
			if (rd = '0') then
				outp <= mbank(to_integer(unsigned(addr(3 downto 0))));
			else
				outp <= "1111111111111111";
			end if;
		
			if (wr = '0') then
				mbank(to_integer(unsigned(addr(3 downto 0)))) <= data;
			end if;
		end process;
end am;

		
			
