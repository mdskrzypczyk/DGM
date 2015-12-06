import lc3b_types::*;


module ID(
	input clk,
	input lc3b_ipacket ipacket,
	input lc3b_reg sr1, sr2, dr_meat, wbdr,
	input lc3b_word wbpc, wbdata,
	input sr2_mux_sel,
	input drmux_sel,
	input regfile_mux_sel,
	input load_regfile,

	output lc3b_word sr1_out, sr2_out, sext_out
);

/* internal signals */
lc3b_reg sr2_mux_out, drmux_out;
lc3b_word regfile_data_in;


/* SR2 MUX */
mux2 #(.width(3)) sr2_mux
(
	.sel(sr2_mux_sel),
	.a(sr2),
	.b(dr_meat),
	.f(sr2_mux_out)
);

/* Register load data */
mux2 #(.width(16)) regfile_mux
(
	.sel(regfile_mux_sel),
	.a(wbdata),
	.b(wbpc),
	.f(regfile_data_in)
);

mux2 #(.width(3)) drmux(
	.sel(drmux_sel),
	.a(wbdr),
	.b(3'b111),
	.f(drmux_out)
);

/* Register File */
regfile regfile_module	
(
	.clk(clk),
	.load(load_regfile),
	.in(regfile_data_in),
	.src_a(sr1),
	.src_b(sr2_mux_out),
	.dest(drmux_out),
	.reg_a(sr1_out),
	.reg_b(sr2_out)	
);

/* Super S/ZEXT */
SUPER_SEXT sext_module
(
	.in(ipacket.inst),
	.opcode(ipacket.inst[15:12]),
	.out(sext_out)
);

endmodule : ID