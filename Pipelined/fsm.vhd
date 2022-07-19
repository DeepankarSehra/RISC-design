library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fsm is
	port(ir : in std_logic_vector(15 DOWNTO 0); 
		invalid_state : in std_logic;
		reset : in std_logic;
		clk : in std_logic;
		C : in std_logic;
		Z : in std_logic;
		Rf_a3 : in std_logic_vector(2 DOWNTO 0);
		rst_i : out std_logic; 
		currentstate : inout std_logic_vector(4 DOWNTO 0);
		control_signal : out std_logic_vector(37 DOWNTO 0);
		nextstate : inout std_logic_vector(4 DOWNTO 0));
end fsm;

architecture arch of fsm is
component statereg is 
 
port(	input_reg: in std_logic_vector(15 downto 0);
output: out std_logic_vector(15 downto 0);
en: in std_logic;
clk,rst: in std_logic);

end component;

 


begin 


	state : statereg port map (input_reg => nextstate, rst => reset, clk => clk,output => currentstate);
	
	statelogic  : process(currentstate, reset, ir,invalid_state, Rf_a3,C,Z)

	variable control_variable :  std_logic_vector(37 downto 0);
	
	begin 
     
	 
		if reset = '1' then

			nextstate <= "00001";
            control_signal(6)<='1';
            control_signal <= (others => '0');
            --state1
		 
		elsif currentstate = "00001" then
---State 1
            control_signal(1 downto 0) <= "11";
            control_signal(15 downto 13) <= "111";
            control_signal(18 downto 16) <= "110";
            
            control_signal(4)<='1';
            control_signal(18)<='1';
           
            control_signal(31)<='1';
           

            control_signal <= (others => '0');



--nextstate logic 
            if(ir(15 downto 12) = "1010") then
                nextstate <= "10000";
  
            elsif (ir(15 downto 12)="0000" or ir(15 downto 12)="0001" or ir(15 downto 12)="0010" or ir(15 downto 12)="0111" or ir(15 downto 12)= "0101" or ir(15 downto 12)="1100" or ir(15 downto 12)="1101" or ir(15 downto 12) = "1000") then
                nextstate <= "00010";
            elsif (ir(15 downto 12)="0100") then
                nextstate <= "00110";
            elsif(ir(15 downto 12) ="1001") then 
                 nextstate <= "01111";
            end if;
				
		elsif currentstate = "00010" then 
	--state 2 		
	
    control_signal(7) <= '1';
    control_signal(28 downto 27) <= "11";
  
    control_signal <= (others => '0');

       
            --nextstate logic 
            if(ir(15 downto 12) = "0000" or ir(15 downto 12) = "0001" or ir(15 downto 12) = "0010"  ) then
                nextstate <= "00011";
            elsif (ir(15 downto 12) ="0111" or ir(15 downto 12)="0101") then
                nextstate <= "00111";
            elsif (ir(15 downto 12) ="1100") then
                    nextstate <= "01010";
            elsif (ir(15 downto 12) ="1101") then
                    nextstate <= "01100";

            elsif (ir(15 downto 12) ="1000" and Z='0') then
                    nextstate <= "00101";

             elsif (ir(15 downto 12) ="1000" and Z='1') then
                    nextstate <= "01110";
 
            end if;
			
--state 3 			
		elsif currentstate = "00011" then
            control_signal(15 downto 14) <= "01";
            control_signal(18 downto 16) <= "010";
            control_signal(26 downto 25) <= "11";
            control_signal(21) <= '1';

            

            control_signal <= (others => '0');
            if(ir(3 downto 0)="1000") then
                if(ir(15 downto 13 )="000" or ir(15 downto 13 )="010" or ir(15 downto 13 )="100") then
                    control_signal(20 downto 19) <= "01";
                
                elsif(ir(15 downto 13 )="110") then
                    control_signal(20 downto 19) <= "10";
					 end if;
            elsif(ir(3 downto 0)="0000") then
                control_signal(20 downto 19) <= "01";
            elsif(ir(3 downto 0)="0100") then
                    control_signal(20 downto 19) <= "11";
       
				end if;
            --nextstate logic 
            if (ir(15 downto 12) = "0000" or ir(15 downto 12) = "0001" or ir(15 downto 12) = "0010" ) then
                nextstate <= "00100";

 
            end if;
        
--state 4
            elsif (currentstate = "00100") then
                
                control_signal(9 downto 8) <= "11";
                control_signal(5) <= '1';
                control_signal <= (others => '0');
    
           
                --nextstate logic 
                if(ir(15 downto 12) = "0000" or ir(15 downto 12) = "0001" or ir(15 downto 12) = "0010" ) then
                    nextstate <= "00101";
    
     
                end if;

---state 5
                elsif currentstate = "00101" then
       
                    control_signal(12 downto 10) <= "110";
                
                    control_signal(5) <= '1';
        
        
                    control_signal <= (others => '0');
        
               
                    --nextstate logic 
             
			
   
--state 6 
            elsif currentstate = "00110" then
					 control_signal(9 downto 8) <= "10";
					 control_signal(12 downto 10) <= "001";
                control_signal <= (others => '0');
                


                --nextstate logic 
                if(ir(15 downto 12) = "0100"   ) then
                    nextstate <= "00101";


                end if;
--state 7 
            elsif currentstate = "00111" then
                 control_signal(15 downto 14)<= "01";
					  control_signal(18 downto 16) <= "100";
					  control_signal(21) <= '0';
					  control_signal <= (others => '0');

                --nextstate logic 
                if(ir(15 downto 12) = "0111"   ) then
                    nextstate <= "01000";
                elsif (ir(15 downto 12)="0101") then
                    nextstate <= "01001";
                    


                end if; 

--state 8
            elsif currentstate = "01000" then
                 control_signal(2) <= '0';
					  control_signal(12 downto 10) <= "010";
					  control_signal(9 downto 8) <= "10";
					  control_signal(22) <= '1';
					  control_signal <= (others => '0');

                --nextstate logic 
                if(ir(15 downto 12) = "0111"   ) then
                    nextstate <= "00101";


                end if; 

--state 9 
				elsif currentstate = "01001" then
					 control_signal(2) <= '0';
					 control_signal(3) <= '1';
					 control_signal(12 downto 10) <= "110";
					 control_signal(9 downto 8) <= "00";
					 control_signal <= (others => '0');

    --nextstate logic 
   
    
--state 10 
				elsif currentstate = "01010" then
					 control_signal(23 downto 22) <= "11";
					 control_signal(2) <= '0';
					 control_signal <= (others => '0');
    
        --nextstate logic 
        if(ir(15 downto 12)="1100") then
            nextstate<="01011";
        
        end if;
    
--state 11
elsif currentstate = "01011" then
    control_signal(9 downto 8) <= "01";
    control_signal(5) <='1';
    control_signal(12) <='1';
    control_signal(21) <='1';
    control_signal(29) <='1';
    control_signal(19 downto 18) <= "11";

    control_signal <= (others => '0');


    --nextstate logic 
    if(ir(15 downto 12)="1100") then
        nextstate<="00101";
    
    end if; 
--state 12
elsif currentstate = "01100" then
    control_signal(22) <='1';
    control_signal(30) <='1';
    control_signal(27) <='1';
   
    control_signal <= (others => '0');


    --nextstate logic 
    if(ir(15 downto 12)="1101") then
        nextstate<="01101";
    
    end if; 
--state 13
elsif currentstate = "01101" then
    control_signal(29) <='1';
    control_signal(24 downto 23) <="11";
    control_signal(22 downto 21) <="01";
    control_signal(15 downto 14) <="01";
    control_signal(18 downto 16) <="110";
    control_signal(2) <='1';
   
    control_signal <= (others => '0');



    --nextstate logic 
    if(ir(15 downto 12)="1101") then
        nextstate<="00101";
    
    end if;

--state 14 
elsif currentstate = "01110" then
     
    control_signal(20 downto 19) <="11";
    control_signal(15 downto 14) <="11";
    control_signal(18 downto 16) <="100";
    control_signal <= (others => '0');


    --nextstate logic 
    if (ir(15 downto 12) ="1000" and Z='1') then
        nextstate <= "00101";

    end if; 

  
--state 15
elsif currentstate = "01111" then
    control_signal(13 downto 10) <="1110";
   
    control_signal(15 downto 14) <="11";
    control_signal(9 downto 8) <="10";
    control_signal(31 downto 30) <="10";
    control_signal <= (others => '0');


    --nextstate logic 
    if (ir(15 downto 12) ="1001" ) then
        nextstate <= "00101";

    end if;
--state 16
elsif currentstate = "10000" then
     
    control_signal(5 downto 4) <="10";

    control_signal(9 downto 7) <="101";
    control_signal(12 downto 10) <="001";
    control_signal(31 downto 30) <="10";
    control_signal <= (others => '0');


    --nextstate logic 
    if (ir(15 downto 12) ="1010" ) then
        nextstate <= "00101";
	 end if;

	else  
			 
			nextstate <= "00001";
			
			

end if;
		
		if currentstate = "10000" then
			rst_i <= '1';
		else 
			rst_i <= '0';
		end if;

	control_signal <= control_variable;
	
	end process;					
end arch ; -- arch