import lc3b_types::*;

module ie_mem_meat(
	input clk,
	input load_addr,
	input stall,
	input lc3b_ipacket in_ipacket,
	input lc3b_word ie_alu_res,	//alu output 
	input lc3b_word ie_addrgen_res,	//adder output 
	input lc3b_word meat_mem_rdata,	//memory data back 
	input lc3b_word sr_store_in,
	
	output lc3b_word sr_store_out,
	output lc3b_word meat_alu_out, 
	output lc3b_word meat_addrgen_out,
	output logic hold,	//for ldi,sti 
	output lc3b_ipacket out_ipacket
);

/* Internal Signals */
lc3b_ipacket ipacket;
lc3b_word alu_reg;
lc3b_word sr_store;
lc3b_word addrgen_reg;
logic hold_reg;

/* Initialize to zero */
initial
begin
   ipacket = 1'b0;
	sr_store = 16'b0;
	alu_reg = 16'h0;
	addrgen_reg = 16'h0;
	hold_reg = 1'b0;
end

/* Store results for IE */
always_ff @ (posedge clk)
begin
	if(~stall)
	begin
		ipacket = in_ipacket;
		alu_reg = ie_alu_res;
		addrgen_reg = ie_addrgen_res;
		sr_store = sr_store_in;
		
		/* LDI/STI Logic */
		hold_reg = 0;
		if(in_ipacket.opcode == op_ldi || in_ipacket.opcode == op_sti)
		begin
			hold_reg = 1;
		end
	end
	
	/* Logic to reload address for LDI/STI */
	else if(load_addr)
	begin
		addrgen_reg = meat_mem_rdata;
		hold_reg = 0;
	end
end

/* Output data to MEM Stage */
always_comb
begin	
	out_ipacket = ipacket;
	meat_alu_out = alu_reg;
	meat_addrgen_out = addrgen_reg;
	hold = hold_reg;
	sr_store_out = sr_store;
end

endmodule : ie_mem_meat