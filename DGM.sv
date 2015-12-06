import lc3b_types::*;

module DGM(
	input clk,	
		/* output signals dual memory */ 
		
 input logic resp,
 input lc3b_burst rdata,
 output lc3b_word address,
 output logic read,
 output logic write,
 output lc3b_burst wdata
	
);

 /*internal signals */
lc3b_word if_memaddr, if_mem_rdata, mem_memaddr, mem_mem_rdata, mem_mem_wdata;
logic [1:0] if_mem_byte_enable, mem_mem_byte_enable;
logic if_mem_resp, if_memread, mem_mem_resp, mem_memread, mem_memwrite;
logic IF_read, IF_write, MEM_read, MEM_write, l2i_resp, l2d_resp;
lc3b_word IF_address,  MEM_address;
lc3b_burst l2i_rdata,IF_wdata, l2d_rdata, MEM_wdata ;
logic l2_read, l2_write, l2_resp;
lc3b_word l2_address; 
lc3b_burst l2_wdata, l2_rdata;
lc3b_word l1i_read_miss_count, l1i_write_miss_count, l1d_read_miss_count, l1d_write_miss_count, l2_read_miss_count, l2_write_miss_count;
logic vc_read, vc_write, vc_resp;
lc3b_word vc_address;
lc3b_burst vc_wdata, vc_rdata;

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
	  .mem_memwrite(mem_memwrite),

	  .l1i_read_miss_count(l1i_read_miss_count),
	  .l1i_write_miss_count(l1i_write_miss_count),
	  .l1d_read_miss_count(l1d_read_miss_count),
	  .l1d_write_miss_count(l1d_write_miss_count),
	  .l2_read_miss_count(l2_read_miss_count),
	  .l2_write_miss_count(l2_write_miss_count)
);

cache cache_money(
	.clk(clk),
	.if_memaddr(if_memaddr),
	.if_mem_byte_enable(if_mem_byte_enable),
	.if_memread(if_memread),
	.if_mem_wdata(16'b0), //never writes to memory 
	.if_mem_write(1'b0),
	.if_mem_rdata(if_mem_rdata),
	.if_mem_resp(if_mem_resp),
	
	.l2i_resp(l2i_resp),
	.l2i_rdata(l2i_rdata),
	.IF_address(IF_address),
	.IF_wdata(IF_wdata),
	.IF_read(IF_read),
	.IF_write(IF_write),
	
	.mem_memaddr(mem_memaddr),
	.mem_mem_byte_enable(mem_mem_byte_enable),
	.mem_memread(mem_memread),
	.mem_mem_wdata(mem_mem_wdata),
	.mem_mem_write(mem_memwrite),
	.mem_mem_resp(mem_mem_resp),
	.mem_mem_rdata(mem_mem_rdata),
	
	.l2d_resp(l2d_resp),
	.l2d_rdata(l2d_rdata),
	.MEM_address(MEM_address),
	.MEM_wdata(MEM_wdata),
	.MEM_read(MEM_read),
	.MEM_write(MEM_write),

	.l1i_read_miss_count(l1i_read_miss_count),
	.l1i_write_miss_count(l1i_write_miss_count),
	.l1d_read_miss_count(l1d_read_miss_count),
	.l1d_write_miss_count(l1d_write_miss_count)
);


 /* the arbiter */
 arbiter arbiter_module(
 // IF cache connection 
	.IF_address(IF_address),
	.IF_read(IF_read),
	.IF_write(IF_write),
	.IF_wdata(IF_wdata),
//MEM cache connection 
	.MEM_address(MEM_address),
	.MEM_read(MEM_read),
	.MEM_write(MEM_write),
	.MEM_wdata(MEM_wdata),
	.l2i_resp(l2i_resp),
	.l2i_rdata(l2i_rdata),
	.l2d_resp(l2d_resp),
	.l2d_rdata(l2d_rdata),
//l2 or memory cache connection 
	.l2_resp(l2_resp),
	.l2_rdata(l2_rdata),
	.l2_address(l2_address),
	.l2_read(l2_read),
	.l2_write(l2_write),
	.l2_wdata(l2_wdata)
 );
 

 
 /* the level two cache */
 cache_module_l2 L2_CACHE(
	.clk(clk),
	// signal connecting to L1 
	.mem_read(l2_read),
	.mem_write(l2_write),
	.mem_address(l2_address),
	.mem_wdata(l2_wdata),
	.mem_byte_enable(2'b11), //byte enable manually set as reading entire thing, should not matter here
	.mem_resp(l2_resp),
	.mem_rdata(l2_rdata),
	
	/*
		.pmem_resp(resp),
	.pmem_rdata(rdata),
	.pmem_read(read),
	.pmem_write(write),
	.pmem_address(address),
	.pmem_wdata(wdata)
	*/
	// signal connecting to Physical or victim cache
	
	.pmem_resp(vc_resp),
	.pmem_rdata(vc_rdata),
	.pmem_read(vc_read),
	.pmem_write(vc_write),
	.pmem_address(vc_address),
	.pmem_wdata(vc_wdata)
 
 );

 /* Victim Cache */
victim_cache the_executioner
(
	//Inputs
   .clk(clk),
	
	.arbiter_address(l2_address),
	
	.read(vc_read),
   .write(vc_write),
   .address(vc_address),
   .wdata(vc_wdata),
	
	.pmem_resp(resp),
	.pmem_rdata(rdata),
	
	//Outputs
	.resp(vc_resp),
   .rdata(vc_rdata),
	
	.pmem_read(read),
	.pmem_write(write),
	.pmem_address(address),
	.pmem_wdata(wdata)
 );
 
endmodule: DGM 
