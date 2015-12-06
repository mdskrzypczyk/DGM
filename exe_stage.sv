import lc3b_types::*;

module exe_stage
(
	input clk,

	input stall,
	input lc3b_ipacket ipacket,
	input lc3b_ipacket mem_ipacket,
	input lc3b_word SEXT,
	input lc3b_word sr1,
	input lc3b_word sr2,
	input logic [1:0] opAmux_sel,
	input logic [1:0] opBmux_sel,
	input logic [1:0] opSrmux_sel,
	input lc3b_word mem_data_forward,
	input lc3b_word wb_data_forward,
	input lc3b_word l1i_read_miss, l1i_write_miss, l1d_read_miss, l1d_write_miss, l2_read_miss, l2_write_miss, bubble_count, 

	output alg_done,
	output logic [1:0] pcmux_sel,
	output lc3b_word pc_addr_out,
	output logic pip_flush,
	output logic br_taken,

	output lc3b_word alu_out,
	output lc3b_word bradd_out,
	output lc3b_word sr_store
);

lc3b_word alumux_out, braddmux_out, alu_res;
lc3b_word opA, opB;
lc3b_word alg_hi_in, alg_lo_in;
lc3b_word alg_hi_bits, alg_lo_bits;
logic br_sig;

assign br_taken = br_sig;

/* BR Add Mux */
mux4 braddmux
(
	.sel(ipacket.braddmux_sel),
	.a(ipacket.pc),
	.b(sr2),
	.c(16'h0),
	.d(16'h0),
	
	.f(braddmux_out)
);

/* BR Adder */
adder bradd
(
	.a(SEXT),
	.b(braddmux_out),
	
   .out(bradd_out)
);

alg_unit algebra(
	.clk(clk),
	.opA(opA),
	.opB(opB),
	.op_x_bits(ipacket.op_x_bits),
	
	.done(alg_done),
	.hi_bits(alg_hi_in),
	.lo_bits(alg_lo_in)
);

register alg_hi_reg(
	.clk(clk),
	.load(ipacket.load_alg_reg),
	.in(alg_hi_in),
	.out(alg_hi_bits)
);

register alg_lo_reg(
	.clk(clk),
	.load(ipacket.load_alg_reg),
	.in(alg_lo_in),
	.out(alg_lo_bits)
);

/* ALU */
alu alu
(
	.aluop(ipacket.aluop),
	.a(opA),
	.b(opB),
   .f(alu_res)
);

mux16 alu_res_mux(
	.sel(ipacket.alu_res_sel),
	.a(alu_res),
	.b(bubble_count),
	.c(l1i_read_miss),
	.d(l1i_write_miss),
	.e(l1d_read_miss),
	.f(l1d_write_miss),
	.g(l2_read_miss),
	.h(l2_write_miss),
	.i(16'h0),
	.j(alg_lo_in),
	.k(alg_hi_in),
	.l(16'h0),
	.m(16'h0),
	.n(16'h0),
	.o(16'h0),
	.p(16'h0),
	.out(alu_out)
);

/* ALU 2nd Operand Mux */
mux2 #(.width(16)) alumux 
(
	.sel(ipacket.alumux_sel),
	.a(sr2),
	.b(SEXT),
	
	.f(alumux_out)
);

/* opA mux */
mux4 #(.width(16)) opAmux
(
	.sel(opAmux_sel),
	.a(sr1),
	.b(mem_data_forward),
	.c(wb_data_forward),
	.d(16'b0), 
	
	.f(opA)
);

/* opB mux */
mux4 #(.width(16)) opBmux 
(
	.sel(opBmux_sel),
	.a(alumux_out),
	.b(mem_data_forward),
	.c(wb_data_forward),
	.d(16'b0), 
	
	.f(opB)
);

/* SR forwarding */
mux4 #(.width(16)) opSrmux
(
	.sel(opSrmux_sel),
	.a(sr2),
	.b(mem_data_forward),
	.c(wb_data_forward),
	.d(16'b0), 
	
	.f(sr_store)
);


/* Branch Resolution */
ex_branch_res ex_branch_resolution(
	.clk(clk),
	.ex_ipacket(ipacket),
	.mem_ipacket(mem_ipacket),
	.ex_alu_res(alu_out),
	.ex_addr_res(bradd_out),
	.mem_res(mem_data_forward),
	.branch_enable(br_sig),
	.br_addr(pc_addr_out),
	.pcmux_sel(pcmux_sel)
);

flush_gen pipe_flush(
	.opcode(ipacket.opcode),
	.branch_enable(br_sig),
	.stall(stall),
	.flush(pip_flush)
);


endmodule : exe_stage