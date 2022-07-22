library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity hazard1 is 
	port( 
		Rf_A3 : in std_logic_vector(2 downto 0);
		Rf_valid: in std_logic_vector(2 downto 0);
		Reg_id    : in std_logic_vector(15 downto 0);
		ir   : in std_logic_vector(15 downto 0);
		opcode	: in std_logic_vector(3 downto 0);
		clk: in std_logic;
		---------------------------------------
		amux_sel : out std_logic;
		dmux_in: out std_logic_vector(15 downto 0));
end entity;

architecture hazard of hazard1 is
	signal R7_flush, LH_R7_flush, JLR_flush : std_logic := '0';
	signal clear : std_logic := '0';
begin

	amux_sel   <= clear;
	
	LH_R7_flush  <= '1' when(opcode = "0011" and Rf_A3 = "111" and Rf_valid(0) = '1') else '0';
	R7_flush  <= '1' when(opcode = "1011" and Rf_A3 = "111" and Rf_valid(0) = '1') else '0';
	JLR_flush  <= '1' when(opcode = "1001") else '0';
	data_mux_RR  <= Reg_id when(R7_flush = '1') else D3_reg_write;
	clear  <= LH_R7_flush or R7_flush or JLR_flush;
end architecture hazard;


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity stalling is 
	port( 
		D1_in : in std_logic_vector(2 downto 0);
		D2_in : in std_logic_vector(2 downto 0);
		lw_sel : in std_logic;
		-- LW from ID_RR
		A3_in : in std_logic_vector(2 downto 0);
		if_valid : in std_logic_vector(2 downto 0);
		decoder_valid : in std_logic_vector(2 downto 0);
		opcode_reg, reg_number: in std_logic_vector(3 downto 0);
		clk: in std_logic;
		---------------------------------------
		disable_out : out std_logic := '0';
		SM_start_control : out std_logic := '0');
end entity;

-- to be changed staller
architecture hazard of staller is 
	signal disable : std_logic := '0';
begin 
	process(opcode_reg, reg_number, clk, decoder_AR1, decoder_AR2, lw_sel, 
		if_valid , A3_in, decoder_valid, IF_ID_cond)
	begin
		SM_start_control <= '0';
		disable <= '0';
		if(lw_sel = '1') then
			if(reg_number = "0101" and (decoder_AR2 = A3_in)) then   --SW ins in IF_ID
				disable <= '0';
			elsif(reg_number = "0111") then		--SM
				if(decoder_AR1 = A3_in) then
					disable <= '1';
					SM_start_control <= '1';
				end if;
			elsif (((decoder_AR1 = A3_in) and decoder_valid(2) = '1') or ((decoder_AR2 = A3_in) and decoder_valid(1) = '1')) then
				disable <= '1';
			elsif (((reg_number(3 downto 2) & reg_number(0)) = "000")) then
				disable <= '1';
			end if;
		end if;	
	end process;
	
	disable_out <= disable;
	

end architecture;

