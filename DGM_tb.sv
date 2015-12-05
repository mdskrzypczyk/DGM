import lc3b_types::*;

module DGM_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
/*
logic a_mem_resp;
logic a_mem_read;
logic a_mem_write;
logic [1:0] a_mem_byte_enable;
logic [15:0] a_mem_address;
logic [15:0] a_mem_rdata;
logic [15:0] a_mem_wdata;

logic b_mem_resp;
logic b_mem_read;
logic b_mem_write;
logic [1:0] b_mem_byte_enable;
logic [15:0] b_mem_address;
logic [15:0] b_mem_rdata;
logic [15:0] b_mem_wdata;
*/

logic resp;
logic [127:0] rdata;
logic read;
logic write;
logic [15:0] address;
logic [127:0] wdata;


/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

DGM top(
		
	.clk(clk),
	.resp(resp),
	.rdata(rdata),
	.address(address),
	.read(read),
	.write(write),
	.wdata(wdata)
);


physical_memory the_memory(
	.clk(clk),
	.read(read),
	.write(write),
	.address(address),
	.wdata(wdata),
	.resp(resp),
	.rdata(rdata)
);

endmodule : DGM_tb


