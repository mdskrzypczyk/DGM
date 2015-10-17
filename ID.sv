import lc3b_types::*;


module ID(
	input clk,
	input lc3b_ipacket ipacket,
	input lc3b_reg sr1, sr2, dr,
	input lc3b_word wbpc, wbdata, instruction,
	input sr2_mux_sel,
	input regfile_mux_sel,
	input load_regfile,

	output lc3b_word sr1_out, sr2_out, sext_out,
	output lc3b_ipacket ipacket_out
);

/* internal signals */
lc3b_reg sr2_mux_out;
lc3b_word regfile_data_in;

/* SR2 MUX */
mux2 #(.width(3)) sr2_mux
(
	.sel(sr2_mux_sel),
	.a(sr2),
	.b(dr),
	.f(sr2_mux_out)
);

/* Register load data */
mux2 #(.width(16)) regfile_mux
(
	.sel(regfile_mux_sel),
	.a(wbpc),
	.b(wbdata),
	.f(regfile_data_in)
);

/* Register File */
regfile regfile_module	
(
	.clk(clk),
	.load(load_regfile),
	.in(regfile_data_in),
	.src_a(sr1),
	.src_b(sr2_mux_out),
	.dest(dr),
	.reg_a(sr1_out),
	.reg_b(sr2_out)	
);

/* Super S/ZEXT */
SUPER_SEX sex_module
(
	.in(instruction),
	.opcode(instruction[15:12]),
	.out(sext_out)
);

endmodule : ID