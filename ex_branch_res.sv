import lc3b_types::*;

module ex_branch_res(
	input clk,
	input lc3b_ipacket ex_ipacket, mem_ipacket,
	input lc3b_word ex_alu_res, ex_addr_res, mem_res,
	
	output logic branch_enable,
	output lc3b_word br_addr,
	output logic [1:0] pcmux_sel
);

lc3b_nzp ex_alu_nzp, ex_addr_nzp, mem_nzp, cc;
logic [1:0] pc_addr_sel;
logic br_sig;

assign branch_enable = br_sig;

mux4 braddmux(
	.sel(pc_addr_sel),
	.a(ex_alu_res),
	.b(ex_addr_res),
	.c(mem_res),
	.d(16'h0),
	.f(br_addr)
);


pcmuxgen pcmuxselgen(
	.branch_enable(br_sig),
	.ex_ipacket(ex_ipacket),
	.mem_ipacket(mem_ipacket),
	.wb_pc_mux_sel(pcmux_sel),
	.pc_addr_sel(pc_addr_sel)
);

gencc ex_alu_cc_gen(
	.in(ex_alu_res),
	.out(ex_alu_nzp)
);

gencc ex_addr_cc_gen(
	.in(ex_addr_res),
	.out(ex_addr_nzp)
);

gencc mem_cc_gen(
	.in(mem_res),
	.out(mem_nzp)
);

ex_branch_cc cc_module(
	.clk(clk),
	.mem_opcode(mem_ipacket.opcode),
	.ex_res_bits(ex_ipacket.br_res_bits),
	.mem_res_bits(mem_ipacket.br_res_bits),
	.ex_alu_nzp(ex_alu_nzp),
	.ex_addr_nzp(ex_addr_nzp),
	.mem_nzp(mem_nzp),
	.cc(cc)
);

cccomp CCComp(
	.cc(cc),
	.nzp(ex_ipacket.nzp),
	.mem_nzp(mem_nzp),
	.opcode(ex_ipacket.opcode),
	.branch_enable(br_sig)
);
endmodule : ex_branch_res