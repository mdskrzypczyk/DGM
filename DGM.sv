import lc3b_types::*;

module DGM(
	input clk,	
		/* output signals dual memory */ 
		
 input logic resp,
 input lc3b_burst rdata,
 output lc3b_word address,
 output logic read,
 output logic write,
 input lc3b_burst wdata,

	//testing
input pmem_resp_t

	
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
	.MEM_write(MEM_write)

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
	// signal connecting to Physical 
	.pmem_resp(resp),
	.pmem_rdata(rdata),
	.pmem_read(read),
	.pmem_write(write),
	.pmem_address(address),
	.pmem_wdata(wdata)
 );
 
 
 
 
 


//static output test signals
logic resp_t, pmem_read_t, pmem_write_t;
lc3b_burst rdata_t, pmem_wdata_t;
lc3b_word pmem_address_t;

victim_cache vc_test
(
   .clk(clk),
	
	.arbiter_address(16'h0),
	
	.read(1'b1),
   .write(1'b0),
   .address(16'haaaa),
   .wdata(128'h0),
	
	.pmem_resp(pmem_resp_t),
	.pmem_rdata(128'hbbbb),
	
	//outputs
   .resp(resp_t),
   .rdata(rdata_t),
	
	.pmem_read(pmem_read_t),
	.pmem_write(pmem_write_t),
	.pmem_address(pmem_address_t),
	.pmem_wdata(pmem_wdata_t)
);

 
 






endmodule: DGM 
