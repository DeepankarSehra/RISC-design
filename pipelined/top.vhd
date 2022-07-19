
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
port( clk: in std_logic;
		rst: in std_logic);
end entity;

architecture behav of datapath is

--component declarations.

component fsm is
	port(ir : in std_logic_vector(15 DOWNTO 0); 
		invalid_state : in std_logic;
		rst : in std_logic;
		clk : in std_logic;
		C : in std_logic;
		Z : in std_logic;
		Rf_a3 : in std_logic_vector(2 DOWNTO 0);
		rst_i : out std_logic; 
		currentstate : inout std_logic_vector(4 DOWNTO 0);
		control_signal : out std_logic_vector(37 DOWNTO 0);
		nextstate : inout std_logic_vector(4 DOWNTO 0));
end component;

component single_reg is
port(	input_reg: in std_logic_vector(15 downto 0);
		output: out std_logic_vector(15 downto 0);
		en: in std_logic;
		rst: in std_logic;
		clk: in std_logic);
end component;

component registers is 
	port( rf_a1,rf_a2,rf_a3   : in std_logic_vector(2 DOWNTO 0);
			rst : in std_logic; -- async. clear.
			clk : in std_logic; 
			wr  : in std_logic; 
			rf_d3 : in std_logic_vector(15 downto 0);
			rf_d1,rf_d2,R7  : out std_logic_vector(15 DOWNTO 0)); 
end component;

component PE is 
	port (inp: in std_logic_vector(7 downto 0);
			invalid_state : out std_logic;
			--nextstate: out std_logic_vector(7 downto 0);
			outp: out std_logic_vector(2 downto 0));
end component;

component alu is
port( in1, in2: in std_logic_vector(15 downto 0);
		alu_out: out std_logic_vector(15 downto 0);
		carry: out std_logic;
		zero: out std_logic;
		alu_sel: in std_logic;
		alu_sel2: in std_logic); --add and nand and xor
end component;

component mux2 is
	port (in1,in2 : in std_logic_vector(15 downto 0);
		muxout : out std_logic_vector(15 downto 0);
		sel : in std_logic);
end component;

component mux4 is
	port (s0,s1,s2,s3 : in std_logic_vector(15 downto 0);
		z : out std_logic_vector(15 downto 0);
		dn1,dn0 : in std_logic);
end component;

component mux2_3 is
	port (in1,in2 : in std_logic_vector(15 downto 0);
		muxout : out std_logic_vector(15 downto 0);
		sel : in std_logic);
end component;

component mux4_3 is
	port (s0,s1,s2,s3 : in std_logic_vector(2 downto 0);
		z : out std_logic_vector(2 downto 0);
		dn1,dn0 : in std_logic);
end component;

component mux8 is
	port (s0,s1,s2,s3,s4,s5,s6,s7 : in std_logic_vector(15 downto 0);
		z : out std_logic_vector(15 downto 0);
		dn1,dn0,dn2 : in std_logic);
end component;

component sign6 is
port( input: in std_logic_vector(5 downto 0);
		output: out std_logic_vector(15 downto 0));
end component;

component sign9 is
port( input: in std_logic_vector(8 downto 0);
		output: out std_logic_vector(15 downto 0));
end component;

component sign9_2 is
port( input: in std_logic_vector(8 downto 0);
		output: out std_logic_vector(15 downto 0));
end component;

component memory is
port(  wr: in std_logic;
		 rd: in std_logic;
		 init: in std_logic;
		 data: in std_logic_vector(15 downto 0);
		 addr: in std_logic_vector(15 downto 0);
		 outp: out std_logic_vector(15 downto 0));
end component;

component ir is
port(input_reg: in std_logic_vector(15 downto 0);
         output: out std_logic_vector(15 downto 0);
         en: in std_logic;
         clk,rst: in std_logic);
end component;

signal input_ir: std_logic_vector(15 downto 0);
signal imm9s: std_logic_vector(8 downto 0);
signal imm6s: std_logic_vector(5 downto 0);
signal pen_output: std_logic_vector(2 downto 0);
signal temp1,alu_in1, alu_in2, alu_o, reg_bank_o1, reg_bank_o2, E1, E2, register_write, R7_out, T2_out,T3_out,T4_out,out_ir,input_reg1, out9s, out6s, zero16, one16, T3_in_out, T4_in_out, T1_out, imem_out, idata_in, imem_addr, dmem_out, ddata_in, dmem_addr, pc_out, out9s_2: std_logic_vector(15 downto 0);
signal c, z, T1_en, T1_rst, T2_en, T2_rst,T3_en, T3_rst, T4_en, A3_sel1, A3_sel2, A1_sel, write_flag, T3_mux_sel, T4_mux_sel, imem_write, imem_read, dmem_write, dmem_read, ir_en, dmem_init,imem_init, rmux_sel1, rmux_sel2, rmux_sel3, qmux_sel1, qmux_sel2, alu_1, alu_2, amux_sel, dmux_sel, d3_sel1, d3_sel2, d3_sel3, pc_sel, invalid_state: std_logic;
signal ra, rb, rc, A1, A2, A3: std_logic_vector(2 downto 0);
signal out_ir0to8: std_logic_vector(8 downto 0);
signal out_ir0to5: std_logic_vector(5 downto 0);
signal out_ir0to7: std_logic_vector(7 downto 0);
signal nextstate: std_logic_vector(4 downto 0);

begin
zero16 <= "0000000000000000";
one16 <= "0000000000000001";
instruction: single_reg port map(input_reg=>input_ir, output=>out_ir,en => ir_en,clk=>clk, rst=>rst);

out_ir0to8 <= out_ir(8 downto 0);
out_ir0to5 <= out_ir(5 downto 0);
out_ir0to7 <= out_ir(7 downto 0);

Amux: mux2 port map(in1=>T1_out, in2=> T2_out, muxout => dmem_addr, sel=>amux_sel);

Dmux: mux2 port map(in1=>E1, in2=> E2, muxout=> ddata_in, sel=>dmux_sel);

SE9: sign9 port map(input=>out_ir0to8, output => out9s);

SE6: sign6 port map(input => out_ir0to5, output=> out6s);

SE9_2: sign9_2 port map(input=>out_ir0to8, output=>out9s_2);

PC_mux: mux2 port map(in1=> alu_o, in2=> reg_bank_o1, muxout=> pc_out, sel=> pc_sel);

D_3: mux8 port map(s0=>T1_out, s1=> T2_out, s2=> dmem_out, s3=> pc_out, s4=> out9s_2, s5=>one16, s6=> one16, s7=> one16, z=>register_write, dn0=>d3_sel1, dn1=>d3_sel2, dn2=> d3_sel3);

R: mux8 port map(s0=>out9s, s1=>out6s, s2=>E2 , s3=>one16, s4=>zero16,s5=>zero16,s6=>zero16, s7=>zero16,z=>alu_in2, dn0=> rmux_sel1,dn1=>rmux_sel2, dn2=>rmux_sel3);

Q: mux4 port map(s0=>T3_out , s1=>T4_out ,s2=>E1 ,s3=> R7_out,z=>alu_in1 ,dn1=> qmux_sel2, dn0=> qmux_sel1);

ALU_part: alu port map(in1=>alu_in1, in2=>alu_in2, alu_out=> alu_o ,carry=>c, zero=>z, alu_sel=>alu_1, alu_sel2=>alu_2);

reg_bank: registers port map(rf_a1=>A1, rf_a2=>A2 , rf_a3=>A3 , rst=>rst , clk=> clk ,wr=> write_flag, rf_d3=>register_write , rf_d1=>reg_bank_o1, rf_d2=> reg_bank_o2, R7=> R7_out);

T1: single_reg port map(input_reg => reg_bank_o1, output=>E1, en=> T1_en, rst=>rst, clk=>clk);

T2: single_reg port map(input_reg=>reg_bank_o2, output=>E2, en=>T2_en, rst=>rst, clk=> clk);

A_3: mux4_3 port map(s0 => "111", s1=> ra, s2=> pen_output,s3=> rc, z=> A3, dn1=> A3_sel1, dn0=> A3_sel2);

A_1: mux2_3 port map(in1=> pen_output,in2=> rb, muxout=> A1, sel=> A1_sel);

T3_in: mux2 port map(in1=>alu_o , in2=> reg_bank_o2, muxout=> T3_in_out, sel=> T3_mux_sel);

T4_in: mux2 port map(in1=>T1_out , in2=> dmem_out, muxout=> T4_in_out, sel=> T4_mux_sel);

T3: single_reg port map(input_reg=>T3_in_out, output=>T1_out, en=> T3_en, rst=>rst, clk=>clk);

T4: single_reg port map(input_reg=> dmem_out, output=>T2_out, en=> T4_en, rst=>rst, clk=>clk);

memi: memory port map(wr=> imem_write, rd => imem_read, init=>imem_init , data=> idata_in, addr=> imem_addr, outp=> imem_out);

memd: memory port map(wr=> dmem_write, rd=> dmem_read, init=> dmem_init, data=> ddata_in, addr=> dmem_addr, outp=> dmem_out);

priority_encoder: PE port map(inp=>out_ir0to7, invalid_state=>invalid_state, outp=> pen_output);
--all rd and wr are low active in memory related stuff

fsm_inst: fsm port map (ir=>out_ir,invalid_state=>invalid_state,rst=>rst,clk=>clk,C=>c,Z=>z,Rf_a3=>A3,rst_i=>rst,
	control_signal(0)=>imem_read,
	control_signal(1)=>imem_write,
	--read write enable if set high 
	control_signal(2)=>amux_sel,
	control_signal(3)=>dmux_sel,

	control_signal(4)=>ir_en,
	control_signal(5)=>write_flag,
	control_signal(6)=>rst,

	control_signal(7)=>A1_sel,
	control_signal(8)=>A3_sel1,
	control_signal(9)=>A3_sel2,
	control_signal(10)=>d3_sel1,
	control_signal(11)=>d3_sel2,
	control_signal(12)=>d3_sel3,

	control_signal(13)=>pc_sel,

	control_signal(14)=>qmux_sel1,
	control_signal(15)=>qmux_sel2,
	control_signal(16)=>rmux_sel1,
	control_signal(17)=>rmux_sel2,
	control_signal(18)=>rmux_sel3,

	control_signal(19)=>alu_1,
	control_signal(20)=>alu_2,

	control_signal(21)=>T3_mux_sel,
	control_signal(22)=>T4_mux_sel,

	control_signal(23)=>amux_sel,
	control_signal(24)=>dmux_sel,

	control_signal(25)=>dmem_read,
	control_signal(26)=>dmem_write,
	control_signal(27)=>pc_sel,

	control_signal(28)=>c,
	control_signal(29)=>z,

	control_signal(30)=>T1_en,
	control_signal(31)=>T2_en,
	control_signal(32)=>T3_en,
	control_signal(33)=>T4_en,
	nextstate => nextstate);
	
end behav;


