import lc3b_types::*;

module WB(
	/* data input */
	input clk,
	input lc3b_word mem_in, alu_in,
	input lc3b_word br_addr,
	input lc3b_ipacket ipacket, 
	
	/* data output */
	output lc3b_word br_addr_out,
	output lc3b_word wbpc,
	output lc3b_reg wbdr,
	output logic wbdrmux_sel,
	output logic[1:0] pcmux_sel,
	output lc3b_word wbdata,
	output logic regfile_mux_sel,
	output logic load_regfile
);

/* internal signals */
lc3b_nzp cc_out, gen_out;
logic br_taken;

assign regfile_mux_sel = ipacket.regfile_mux_sel;
assign load_regfile = ipacket.load_regfile;
assign br_addr_out = br_addr;
assign wbpc = ipacket.pc;
assign wbdr = ipacket.dr_sr;
assign wbdrmux_sel = ipacket.drmux_sel;

/* GenCC module */
gencc genccmodule(
	.in(wbdata),
	.out(gen_out)
);


mux4 #(.width(16)) cc_mux
(
	.sel(ipacket.cc_mux_sel),
	.a(alu_in),
	.b(mem_in),
	.c(br_addr),
	.d(16'b0),
	.f(wbdata)
);

register #(.width(3)) cc 
(
	.clk(clk),
	.load(ipacket.load_cc),
	.in(gen_out),
	.out(cc_out)
);

cccomp cccomp_module
(
	.nzp(ipacket.nzp),
	.cc(cc_out),
	.branch_enable(br_taken)
);

pcmuxgen pcmuxselgen(
	.pcmux_sel(ipacket.pcmux_sel),
	.opcode(ipacket.opcode),
	.branch_enable(br_taken),
	.wb_pc_mux_sel(pcmux_sel)
);


endmodule : WB