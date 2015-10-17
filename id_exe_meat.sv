import lc3b_types::*;

module id_exe_meat
(
	input logic clk,
	input logic stall,
	input lc3b_ipacket ipacket_in,
	input lc3b_word sr1_in,
	input lc3b_word sr2_in,
	input lc3b_word sext_in,

	output lc3b_ipacket ipacket_out,
	output lc3b_word sr1_out,
	output lc3b_word sr2_out,
	output lc3b_word sext_out
);

/* Internal registers */
lc3b_word sr1_reg, sr2_reg, sext_reg, ipacket_reg;

/* Initialize to zero */
initial
begin
	sr1_reg = 16'h0;
	sr2_reg = 16'h0;
	sext_reg = 16'h0;
	ipacket_reg = 1'b0;
end

/* Store values if not stalled */
always_ff @ (posedge clk)
begin
	if(~stall)
	begin
		sr1_reg = sr1_in;
		sr2_reg = sr2_in;
		sext_reg = sext_in;
		ipacket_reg = ipacket_in;
	end
end

/* Output to Execute Stage */
always_comb
begin
	sr1_out = sr1_reg;
	sr2_out = sr2_reg;
	sext_out = sext_reg;
	ipacket_out = ipacket_reg;
end

endmodule : id_exe_meat