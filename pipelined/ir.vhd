library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ir is
    port(	input_reg: in std_logic_vector(15 downto 0);
            output: out std_logic_vector(15 downto 0);
            en: in std_logic;
            clk,rst: in std_logic);
end entity;
    
    architecture behav of ir is
    begin
    process(clk,rst,en)
    begin
        if(rst='1')then 
            output <= "0000000000000000";
        elsif(clk'event and clk = '1') then
            if(en ='1') then
                output <= input_reg;
            end if;
     
        end if;
    end process;
    end behav;