library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity PE is 
	port (inp: in std_logic_vector(7 downto 0);
			invalid_state : out std_logic;
			--nextstate: out std_logic_vector(7 downto 0);
			outp: out std_logic_vector(2 downto 0));
end entity;

architecture behave of PE is


begin 

 
	proc : process(inp)
	
		variable temp : std_logic_vector(7 downto 0);
	
	begin
		
		if (inp(0) = '1') then 
			outp <= "000";
			temp := ("11111110" and inp);
		elsif (inp(1) = '1') then 
			outp <= "001";
			temp := ("11111100" and inp);
		elsif (inp(2) = '1') then 
			outp <= "010";
			temp := ("11111000" and inp);
		elsif (inp(3) = '1') then 
			outp <= "011";
			temp := ("11110000" and inp);
		elsif (inp(4) = '1') then 
			outp <= "100";
			temp := ("11100000" and inp);
		elsif (inp(5) = '1') then 
			outp <= "101";
			temp := ("11000000" and inp);
		elsif (inp(6) = '1') then 
			outp <= "110";
			temp := ("10000000" and inp);
		else
			outp <= "111";
			temp := ("00000000" and inp);
		end if;
			
		--nextstate <= temp;
		
		if temp = "00000000" then
			invalid_state <= '1';
		else
			invalid_state <= '0';
		end if;

	end process proc;

end behave;
