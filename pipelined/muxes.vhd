library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2 is
	port (in1,in2 : in std_logic_vector(15 downto 0);
		muxout : out std_logic_vector(15 downto 0);
		sel : in std_logic);
end entity;

architecture struct_mux2 of mux2 is
begin
process(in1, in2, sel)
begin
if (sel='0') then 
	muxout <= in1;
else 
	muxout <= in2;
end if;

end process;
end struct_mux2;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2_3bit is
	port (in1,in2 : in std_logic_vector(15 downto 0);
		muxout : out std_logic_vector(15 downto 0);
		sel : in std_logic);
end entity;

architecture struct_mux2_3bit of mux2_3bit is
begin
process(in1, in2, sel)
begin
if (sel='0') then 
	muxout <= in1;
else 
	muxout <= in2;
end if;

end process;
end struct_mux2_3bit;

-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4 is
	port (s0,s1,s2,s3 : in std_logic_vector(15 downto 0);
		z : out std_logic_vector(15 downto 0);
		dn1,dn0 : in std_logic);
end entity;

architecture struct_mux4 of mux4 is
begin

process(s1,s0,s2,s3,dn0,dn1)
begin
if (dn0='0' and dn1= '0') then 
	z <=s0;
elsif (dn0='1' and dn1= '0') then 
	z <=s1;
elsif (dn0='0' and dn1= '1') then 
	z <=s2;
else  
	z <=s3;
end if;

end process;
end struct_mux4;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4_3bit is
	port (s0,s1,s2,s3 : in std_logic_vector(15 downto 0);
		z : out std_logic_vector(15 downto 0);
		dn1,dn0 : in std_logic);
end entity;

architecture struct_mux4_3bit of mux4_3bit is
begin

process(s1,s0,s2,s3,dn0,dn1)
begin
if (dn0='0' and dn1= '0') then 
	z <=s0;
elsif (dn0='1' and dn1= '0') then 
	z <=s1;
elsif (dn0='0' and dn1= '1') then 
	z <=s2;
else  
	z <=s3;
end if;

end process;
end struct_mux4_3bit;

------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux8 is
  	generic (nbits : integer);
	port (s0,s1,s2,s3,s4,s5,s6,s7 : in std_logic_vector(nbits-1 downto 0);
		z : out std_logic_vector(nbits-1 downto 0);
		dn1,dn0,dn2 : in std_logic);
end entity;
architecture struct_mux8 of mux8 is
begin

process(s0,s1,s2,s3,s4,s5,s6,s7,dn0,dn1,dn2)
begin
if (dn0='0' and dn1= '0' and dn2= '0') then 
	z <=s0;
elsif (dn0='1' and dn1= '0' and dn2= '0') then 
	z <=s1;
elsif (dn0='0' and dn1= '1' and dn2= '0') then 
	z <=s2;
elsif (dn0='1' and dn1= '1' and dn2= '0') then 
	z <=s3;
elsif (dn0='0' and dn1= '0' and dn2= '1') then 
	z <=s4;
elsif (dn0='1' and dn1= '0' and dn2= '1') then 
	z <=s5;
elsif (dn0='0' and dn1= '1' and dn2= '1') then 
	z <=s6;
else 
	z <=s7;
end if;

end process;
end struct_mux8;