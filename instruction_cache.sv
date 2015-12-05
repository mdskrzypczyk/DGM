import lc3b_types::*;

module instruction_cache
(
	input logic clk,
	input lc3b_word mem_address,
	input lc3b_word mem_wdata,
	input logic mem_read,
	input logic mem_write,
	input logic[1:0] mem_byte_enable,
	
	output lc3b_word mem_rdata,
	output logic mem_resp	
);

magic_memory magic_memory 
(
    .clk(clk),
    .read(mem_read),
    .write(mem_write),
    .byte_enable(mem_byte_enable),
    .address(mem_address),
    .wdata(mem_wdata),
	 
    .resp(mem_resp),
    .rdata(mem_rdata)
);

endmodule : instruction_cache