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
		IF_ID_cond : in std_logic_vector(1 downto 0);
		-- LW from ID_RR
		ID_RR_AR3 : in std_logic_vector(2 downto 0);
		ID_RR_valid : in std_logic_vector(2 downto 0);
		decoder_valid : in std_logic_vector(2 downto 0);
		opcode_ID_RR, opcode_IF_ID : in std_logic_vector(3 downto 0);
		clk: in std_logic;
		---------------------------------------
		disable_out : out std_logic := '0';
		SM_start_control : out std_logic := '0');
end entity;

-- to be changed staller
architecture hazard of staller is 
	signal disable : std_logic := '0';
begin 
	process(opcode_ID_RR, opcode_IF_ID, clk, decoder_AR1, decoder_AR2, lw_sel, 
		ID_RR_valid, ID_RR_AR3, decoder_valid, IF_ID_cond)
	begin
		SM_start_control <= '0';
		disable <= '0';
		if(lw_sel = '1') then
			if(opcode_IF_ID = "0101" and (decoder_AR2 = ID_RR_AR3)) then   --SW ins in IF_ID
				disable <= '0';
			elsif(opcode_IF_ID = "0111") then		--SM
				if(decoder_AR1 = ID_RR_AR3) then
					disable <= '1';
					SM_start_control <= '1';
				end if;
			elsif (((decoder_AR1 = ID_RR_AR3) and decoder_valid(2) = '1') or ((decoder_AR2 = ID_RR_AR3) and decoder_valid(1) = '1')) then
				disable <= '1';
			elsif (((opcode_IF_ID(3 downto 2) & opcode_IF_ID(0)) = "000") and (IF_ID_cond = "01")) then
				disable <= '1';
			end if;
		end if;	
	end process;
	
	disable_out <= disable;
	

end architecture;

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity hazard_MM is 
	port( 
		EX_MM_AR3,EX_MM_valid,EX_MM_mux_control : in std_logic_vector(2 downto 0);
		EX_MM_flags : in std_logic_vector(2 downto 0);
		m_out : in std_logic_vector(15 downto 0);
		MM_flags_out : out std_logic_vector(2 downto 0);
		top_MM_mux : out std_logic;
		clear : out std_logic);
end entity;

architecture hazard of hazard_MM is 
begin 
	top_MM_mux <= '1' when (EX_MM_AR3 = "111" and EX_MM_valid(0) = '1' and EX_MM_mux_control = "100") else '0';
	clear 	   <= '1' when (EX_MM_AR3 = "111" and EX_MM_valid(0) = '1' and EX_MM_mux_control = "100") else '0';
	MM_flags_out(2 downto 1) <= EX_MM_flags(2 downto 1);
	MM_flags_out(0) <= '1' when (m_out = "0000000000000000" and EX_MM_mux_control = "100") else '0';
end architecture;

--################################################################################################################

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity hazard_conditional_WB is 
	port( 
		AR3_MM_WB: in std_logic_vector(2 downto 0);
		MM_WB_LS_PC, MM_WB_PC_inc : in std_logic_vector(15 downto 0);
		
		MM_WB_valid		  : in std_logic_vector (2 downto 0);
		-----------------------------------------------------------
		r7_write, top_WB_mux_control, clear: out std_logic;
		r7_select 	: out std_logic_vector(1 downto 0);
		top_WB_mux_data : out std_logic_vector(15 downto 0);
		-----------------------------------------------------------
		is_taken	: in std_logic;
		opcode		: in std_logic_vector(3 downto 0)
		);
end entity;

architecture hazard of hazard_conditional_WB is
	signal JLR_flush,JAL_flush, flush: std_logic;
begin 

	JLR_flush      <= '1' when ( opcode = "1001" and AR3_MM_WB = "111" and MM_WB_valid(0) = '1') else '0';
	JAL_flush      <= '1' when ( opcode = "1000" and AR3_MM_WB = "111" and MM_WB_valid(0) = '1') else '0';
	
 		-- The outputs
	flush <= (JLR_flush or JAL_flush);
	clear 	       	   <= flush;
	top_WB_mux_control <= flush; 
	top_WB_mux_data    <= MM_WB_PC_inc when (flush = '1') else 
			      (others => '0');
	
  	r7_select	   <= "00"  when(opcode = "1001") else "10" when( is_taken = '1' or opcode = "1000") else "01";

	r7_write	   <= '0'  when(AR3_MM_WB = "111" and MM_WB_valid(0) = '1') else '1';  -- Since PC+1 will be written using Reg write

end architecture;
