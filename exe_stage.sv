import lc3b_types::*;

module exe_stage
(
	input lc3b_ipacket ipacket,
	input lc3b_word SEXT,
	input lc3b_word sr1,
	input lc3b_word sr2,
	input opA_sel,
	input opA_fw,
	input opB_sel,
	input opB_fw,
	
	output lc3b_word alu_out,
	output lc3b_word bradd_out,
	output lc3b_word sr_store
);

lc3b_word alumux_out, braddmux_out;
lc3b_word opA,opB;

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
	.a(opA),
	.b(opB),
	
   .f(alu_out)
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
mux2 #(.width(16)) opAmux
(
	.sel(opA_sel),
	.a(sr1),
	.b(opA_fw),
	
	.f(opA)
);

/* opB mux */
mux2 #(.width(16)) opBmux 
(
	.sel(opB_sel),
	.a(alumux_out),
	.b(opB_fw),
	
	.f(opB)
);

assign sr_store = sr2;

endmodule : exe_stage