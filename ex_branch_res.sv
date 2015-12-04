import lc3b_types::*;

module ex_branch_res(
	input clk,
	input lc3b_ipacket ex_ipacket, mem_ipacket,
	input lc3b_word ex_alu_res, ex_addr_res, mem_res,
	
	output logic branch_enable,
	output lc3b_word br_addr
);

lc3b_nzp ex_alu_nzp, ex_addr_nzp, mem_nzp, cc;

mux4 braddmux(
	.sel(ex_ipacket.pc_addr_sel),
	.a(ex_alu_res),
	.b(ex_addr_res),
	.c(mem_res),
	.d(16'h0),
	.f(br_addr)
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
	.res_sel(ex_ipacket.res_sel),
	.ex_alu_nzp(ex_alu_nzp),
	.ex_addr_nzp(ex_addr_nzp),
	.mem_nzp(mem_nzp),
	.ex_res(ex_ipacket.ex_res),
	.mem_res(mem_ipacket.mem_res),
	.cc(cc)
);

cccomp CCComp(
	.cc(cc),
	.nzp(ex_ipacket.nzp),
	.opcode(ex_ipacket.opcode),
	.branch_enable(branch_enable)
);
endmodule : ex_branch_res