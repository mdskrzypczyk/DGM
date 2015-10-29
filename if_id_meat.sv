import lc3b_types::*;

module if_id_meat
(
	input logic clk,
	input logic stall,
	input lc3b_ipacket ipacket_in,
	input flush,
	
	output lc3b_ipacket ipacket_out,
	output lc3b_reg sr1, sr2, dr,
	output logic sr2mux_sel
);

lc3b_ipacket packet;
lc3b_reg meat_sr1, meat_sr2, meat_dr;
logic meat_sr2mux_sel;

/* Initialize internal registers to zero */
initial 
begin 
	packet = 1'b0;
	meat_sr1 = 3'b0;
	meat_sr2 = 3'b0;
	meat_dr = 3'b0;
	meat_sr2mux_sel = 1'b0;
end 

/* Extract necessary data from ipacket, store ipacket */
always_ff @ (posedge clk)
begin 
	if(flush)
	begin
		packet = 1'b0;
		meat_sr1 = 3'b0;
		meat_sr2 = 3'b0;
		meat_dr = 3'b0;
		meat_sr2mux_sel = 1'b0;
	end
	else if(~stall)
	begin 
		packet = ipacket_in;
		meat_sr1 = ipacket_in.sr1;
		meat_sr2 = ipacket_in.sr2;
		meat_dr = ipacket_in.dr_sr;
		meat_sr2mux_sel = ipacket_in.sr2_mux_sel;
	end 
end 

/* Output values to next stage */
always_comb
begin 
	if(~stall)
	begin
		ipacket_out = packet;
		sr1 = meat_sr1;
		sr2 = meat_sr2;
		dr = meat_dr;
		sr2mux_sel = meat_sr2mux_sel;
	end
	
	else
	begin	
		ipacket_out = 1'b0;
		sr1 = 3'b0;
		sr2 = 3'b0;
		dr = 3'b0;
		sr2mux_sel = 1'b0;
	end
end 

endmodule : if_id_meat