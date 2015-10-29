import lc3b_types::*;

module mem_wb_meat(
	/* meat input */
	input lc3b_ipacket ipacket,
	input lc3b_word alu_in, mem_data, br_address,
	input flush,
	
	/* control signal */
	input clk,
	input stall,
	
	/* meat output */
	output lc3b_word mem_data_out, br_address_out, alu_out,
	output lc3b_ipacket ipacket_out 
);

/* Internal signals */
lc3b_ipacket packet;
lc3b_word address, memdata, aludata;
	
/* Initialize data to zero */
initial 
begin 
	address = 16'h0;
	memdata = 16'h0;
	aludata = 16'h0;
	packet = 1'b0;
end 
	
/* Store data from MEM Stage */
always_ff @(posedge clk)
begin 
	if(flush)
	begin
		address = 16'h0;
		memdata = 16'h0;
		aludata = 16'h0;
		packet = 1'b0;
	end
	else if(~stall)  //case not stalling 
	begin 
		address = br_address;
		memdata = mem_data;
		aludata = alu_in;
		packet = ipacket;
	end 		
end 
	
/* Output to WB Stage */
always_comb
begin 
	if(~stall)
	begin
		ipacket_out = packet;
		mem_data_out = memdata;
		br_address_out = address;
		alu_out = aludata;
	end
	
	else
	begin
		ipacket_out = 1'b0;
		mem_data_out = 16'b0;
		br_address_out = 16'b0;
		alu_out = 16'b0;
	end
end 

endmodule : mem_wb_meat