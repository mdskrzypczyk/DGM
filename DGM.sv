import lc3b_types::*;

module DGM(
	input clk,	
	
	/* memory siganls */
	/* IF memory siganls *//*
	output lc3b_word if_memaddr,
	output logic[1:0] if_mem_byte_enable,
	input if_mem_resp,
	input lc3b_word if_mem_rdata,
	output if_memread,*/
	
	/* MEM memory signals*//*
	output lc3b_word mem_memaddr,
	output logic[1:0] mem_mem_byte_enable,
	input mem_mem_resp,
	input lc3b_word mem_mem_rdata,
	output logic mem_memread,
	output lc3b_word mem_mem_wdata,
	output logic mem_memwrite*/
	
	/* physical memory signals */
	input logic resp,
	input lc3b_burst rdata,
	output logic read,
	output logic write,
	output lc3b_word address,
	output lc3b_burst wdata

);

/* internal signals */
lc3b_word if_memaddr, if_mem_rdata, mem_memaddr, mem_mem_rdata, mem_mem_wdata;
logic [1:0] if_mem_byte_enable, mem_mem_byte_enable;
logic if_mem_resp, if_memread, mem_mem_resp, mem_memread, mem_memwrite;




pipeline_datapath the_pip(
	 .clk(clk),
	 /* IF memory  signals */
	 .if_memaddr(if_memaddr),
	 .if_mem_byte_enable(if_mem_byte_enable),
	 .if_mem_resp(if_mem_resp),
	 .if_mem_rdata(if_mem_rdata),
	 .if_memread(if_memread),
	
	/* MEM memory signals*/
	  .mem_memaddr(mem_memaddr),
	  .mem_mem_byte_enable(mem_mem_byte_enable),
	  .mem_mem_resp(mem_mem_resp),
	  .mem_mem_rdata(mem_mem_rdata),
	  .mem_memread(mem_memread),
	  .mem_mem_wdata(mem_mem_wdata),
	  .mem_memwrite(mem_memwrite)

);


cache cache_money(
	.clk(clk),
	.if_memaddr(if_memaddr),
	.if_mem_byte_enable(if_mem_byte_enable),
	.if_memread(if_memread),
	.if_mem_wdata(16'b0), //never writes to memory 
	.if_mem_write(1'b0),
	.mem_memaddr(mem_memaddr),
	.mem_mem_byte_enable(mem_mem_byte_enable),
	.mem_memread(mem_memread),
	.mem_mem_wdata(mem_mem_wdata),
	.mem_mem_write(mem_memwrite),
	.if_mem_resp(if_mem_resp),
	.if_mem_rdata(if_mem_rdata),
	.mem_mem_resp(mem_mem_resp),
	.mem_mem_rdata(mem_mem_rdata),
	.resp(resp),
	.rdata(rdata),
	.read(read),
	.write(write),
	.address(address),
	.wdata(wdata)


);

endmodule: DGM 