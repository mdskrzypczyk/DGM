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
	
	input logic l2i_resp,
	input lc3b_burst l2i_rdata,
	
	
	output lc3b_word if_mem_rdata,
	output logic if_mem_resp,
	output lc3b_word IF_address,
	output lc3b_burst IF_wdata,
	output logic IF_read,
	output logic IF_write,
	
		/* MEM memory signals */
	input lc3b_word mem_memaddr,
	input logic[1:0] mem_mem_byte_enable,
	input logic mem_memread,
	input lc3b_word mem_mem_wdata,
	input logic mem_mem_write,
	
	input logic l2d_resp,
	input lc3b_burst l2d_rdata,

	output logic mem_mem_resp,
	output lc3b_word mem_mem_rdata,
	output lc3b_word MEM_address,
	output lc3b_burst MEM_wdata,
	output logic MEM_read,
	output logic MEM_write,
	
	/* Miss Counter Signals */
	output lc3b_word l1i_read_miss_count, l1i_write_miss_count, l1d_read_miss_count, l1d_write_miss_count
 );
 
 /* cache module from MP2 was used and modified here */

 
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
	.pmem_write(IF_write),
	.read_miss_count(l1i_read_miss_count),
	.write_miss_count(l1i_write_miss_count)
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
	.pmem_write(MEM_write),
	.read_miss_count(l1d_read_miss_count),
	.write_miss_count(l1d_write_miss_count)
 );
 
 
 
 endmodule: cache 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 