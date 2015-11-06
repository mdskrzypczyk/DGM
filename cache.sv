/**
 *	The cache block for pipeline datapath 
 *	It currently contains two level 1 cache, with seperation of Instruction cache 
 *	and memory data cache. They are connected with arbiter in between
 *	
 *	The level two cache is much larger than the level one cache, which hold whwatever 
 * level one has also holds information level 1 dumps
 *
 * evict buffer should be designed after level 2 cache, which constantly writing data 
 * back into memory 
 */
 
 import lc3b_types::*;
 
 module cache(
	/* cache input from data path*/
	input clk,
		/* IF memory signals */
	input lc3b_word if_memaddr,
	input logic[1:0] if_mem_byte_enable,
	input if_memread,
	input lc3b_word if_mem_wdata,
	input logic if_mem_write,
	
		/* MEM memory signals */
	input lc3b_word mem_memaddr,
	input logic[1:0] mem_mem_byte_enable,
	input logic mem_memread,
	input lc3b_word mem_mem_wdata,
	input logic mem_mem_write,
	
	/* cache output signal into pipeline datapath */
		/* IF memory siganls */
	output logic if_mem_resp,
	output lc3b_word if_mem_rdata,
		/* MEM memory signals */
	output logic mem_mem_resp,
	output lc3b_word mem_mem_rdata,
	
	/* signals from cache to physical memory */
		/* input from memory */
	input logic resp,
	input lc3b_burst rdata,
		/* output to memory */
	output logic read,
	output logic write,
	output lc3b_word address,
	output lc3b_burst wdata 
 );
 
 /* cache module from MP2 was used and modified here */
 
 /* internal signals */
 logic IF_read, IF_write, MEM_read, MEM_write, l2_resp, l2i_resp, l2d_resp, l2_read, l2_write;
 lc3b_word IF_address,  MEM_address, l2_address;
 lc3b_burst l2i_rdata,IF_wdata, l2d_rdata, MEM_wdata, l2_rdata, l2_wdata;
 
 /* the instruction cache */
 cache_module IF_cache(
	.clk,
	.mem_address(if_memaddr),
	.mem_rdata(if_mem_rdata),
	.mem_wdata(if_mem_wdata),
	.mem_read(if_memread),
	.mem_write(if_mem_write),
	.mem_byte_enable(if_mem_byte_enable),
	.mem_resp(if_mem_resp),
	.pmem_resp(l2i_resp),
	.pmem_address(IF_address),
	.pmem_rdata(l2i_rdata),
	.pmem_wdata(IF_wdata),
	.pmem_read(IF_read),
	.pmem_write(IF_write)
 );
 
 /* the data cache */
  cache_module MEM_cache(
	.clk,
	.mem_address(mem_memaddr),
	.mem_rdata(mem_mem_rdata),
	.mem_wdata(mem_mem_wdata),
	.mem_read(mem_memread),
	.mem_write(mem_mem_write),
	.mem_byte_enable(mem_mem_byte_enable),
	.mem_resp(mem_mem_resp),
	.pmem_resp(l2d_resp),
	.pmem_address(MEM_address),
	.pmem_rdata(l2d_rdata),
	.pmem_wdata(MEM_wdata),
	.pmem_read(MEM_read),
	.pmem_write(MEM_write)
 );
 
 /* the arbiter */
 arbiter arbiter_module(
	.IF_address(IF_address),
	.IF_read(IF_read),
	.IF_write(IF_write),
	.IF_wdata(IF_wdata),
	.MEM_address(MEM_address),
	.MEM_read(MEM_read),
	.MEM_write(MEM_write),
	.MEM_wdata(MEM_wdata),
	.l2_resp(l2_resp),
	.l2_rdata(l2_rdata),
	.l2i_resp(l2i_resp),
	.l2i_rdata(l2i_rdata),
	.l2d_resp(l2d_resp),
	.l2d_rdata(l2d_rdata),
	.l2_address(l2_address),
	.l2_read(l2_read),
	.l2_write(l2_write),
	.l2_wdata(l2_wdata)
 );
 
 /* the level 2 cache */
 /**    currently we do not need l2 cache 
  cache_module l2_cache(
	.clk,
	.mem_address(l2_address),
	.mem_rdata(l2_rdata),
	.mem_wdata(l2_wdata),
	.mem_read(l2_read),
	.mem_write(l2_write),
	.mem_byte_enable(2'b11), //l2 always store burst !!! need to change 
	.mem_resp(l2_resp),
	.pmem_resp(resp),
	.pmem_address(address),
	.pmem_rdata(rdata),
	.pmem_wdata(wdata),
	.pmem_read(read),
	.pmem_write(write)
 );*/


	
	assign read = l2_read;
	assign write = l2_write;
	assign address = l2_address;
	assign wdata = l2_wdata;
	assign l2_resp = resp;
	assign l2_rdata = rdata;
 
 
 
 endmodule: cache 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 