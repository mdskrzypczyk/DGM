import lc3b_types::*;

module exe_stage
(
	input lc3b_ipacket ipacket,
	input lc3b_word SEXT,
	input lc3b_word sr1,
	input lc3b_word sr2,
	
	output lc3b_word alu_out,
	output lc3b_word bradd_out
);

lc3b_word alumux_out, braddmux_out, sr2_out;

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

/* ALU */
alu alu
(
	.aluop(ipacket.aluop),
	.a(sr1),
	.b(sr2),
	
   .f(alu_out)
);

/* ALU 2nd Operand Mux */
mux2 alumux
(
	.sel(ipacket.alumux_sel),
	.a(sr2_out),
	.b(SEXT),
	
	.f(alumux_out)
);

endmodule : exe_stage