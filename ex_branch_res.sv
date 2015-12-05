import lc3b_types::*;

module ex_branch_res(
	input clk,
	input lc3b_ipacket ex_ipacket_in,
	input lc3b_ipacket mem_ipacket_in,
	input lc3b_word ex_alu_res, ex_addr_res, mem_res,

	
	output logic [1:0] pcmux_sel,
	output logic branch_enable,
	output lc3b_word br_addr
);

lc3b_nzp ex_alu_nzp, ex_addr_nzp, mem_nzp, cc;
logic br_sig;
logic [1:0] addr_sel;

addr_dec braddr_dec(
	.mem_opcode(mem_ipacket_in.opcode),
	.ex_addr_sel(ex_ipacket_in.pc_addr_sel),
	.mem_addr_sel(mem_ipacket_in.pc_addr_sel),
	.addr_sel(addr_sel)
);

pcmux_dec pcmuxsel_dec(
	.mem_opcode(mem_ipacket_in.opcode),
	.ex_pcmux_sel(ex_ipacket_in.pcmux_sel),
	.packet_in(ex_ipacket_in),
	.branch_enable(br_sig),
	.mem_pcmux_sel(mem_ipacket_in.pcmux_sel),
	.pcmux_sel(pcmux_sel)
);

mux4 braddmux(
	.sel(addr_sel),
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
	.res_sel(ex_ipacket_in.res_sel),
	.ex_alu_nzp(ex_alu_nzp),
	.ex_addr_nzp(ex_addr_nzp),
	.mem_nzp(mem_nzp),
	.mem_opcode(mem_ipacket_in.opcode),
	.ex_res(ex_ipacket_in.ex_res),
	.mem_res(mem_ipacket_in.mem_res),
	.cc(cc)
);

cccomp CCComp(
	.cc(cc),
	.mem_nzp(mem_nzp),
	.nzp(ex_ipacket_in.nzp),
	.opcode(ex_ipacket_in.opcode),
	.branch_enable(br_sig)
);

br_dec branch_decider(
	.br_sig(br_sig),
	.ex_opcode(ex_ipacket_in.opcode),
	.mem_opcode(mem_ipacket_in.opcode),
	.branch_enable(branch_enable)
);


endmodule : ex_branch_res