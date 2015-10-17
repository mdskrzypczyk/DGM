import lc3b_types::*;

module if_id_meat
(
	input logic clk,
	input logic stall,
	input lc3b_ipacket ipacket_in,
	
	output lc3b_ipacket ipacket_out,
	output lc3b_reg sr1, sr2, dr,
	output logic sr2mux_sel,
	output lc3b_word instruction
);

lc3b_ipacket packet;
lc3b_reg meat_sr1, meat_sr2, meat_dr; 
lc3b_word instructions; 
logic meat_sr2mux_sel;

/* Initialize internal registers to zero */
initial 
begin 
	packet = 1'b0;
	sr1 = 3'b0;
	sr2 = 3'b0;
	dr = 3'b0;
	instructions = 16'h0;
	meat_sr2mux_sel = 1'b0;
end 

/* Extract necessary data from ipacket, store ipacket */
always_ff @ (posedge clk)
begin 
	if(~stall)
	begin 
		packet = ipacket_in;
		meat_sr1 = ipacket_in.sr1;
		meat_sr2 = ipacket_in.sr2;
		meat_dr = ipacket_in.dr_sr;
		instructions = ipacket_in.inst;
		meat_sr2mux_sel = ipacket_in.sr2_mux_sel;
	end 
end 

/* Output values to next stage */
always_comb
begin 
	ipacket_out = packet;
	sr1 = meat_sr1;
	sr2 = meat_sr2;
	dr = meat_dr;
	instruction = instructions;
	sr2mux_sel = meat_sr2mux_sel;
end 

endmodule : if_id_meat