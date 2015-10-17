import lc3b_types::*;

module WB(
	/* data input */
	input clk,
	input lc3b_word mem_in, alu_in,
	input lc3b_word br_addr,
	input lc3b_ipacket ipacket, 
	input lc3b_nzp nzp_sig,
	
	/* control signal input */
	input cc_mux_sel,
	input load_cc,
	
	/* data output */
	output lc3b_word br_addr_out,
	output logic br_taken,
	output lc3b_word wbdata
);

/* internal signals */
lc3b_nzp cc_out;

assign br_addr_out = br_addr;
	
mux2 #(.width(16)) cc_mux
(
	.sel(cc_mux_sel),
	.a(mem_in),
	.b(alu_in),
	.f(wbdata)
);

register #(.width(3)) cc 
(
	.clk(clk),
	.load(load_cc),
	.in(wbdata),
	.out(cc_out)
);

cccomp cccomp_module
(
	.a(nzp_sig),
	.b(cc_out),
	.f(br_taken)
);


endmodule : WB