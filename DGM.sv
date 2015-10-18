import lc3b_types::*;

module DGM(
	input clk,	
	
	/* memory siganls */
	/* IF memory siganls */
	output lc3b_word if_memaddr,
	output logic[1:0] if_mem_byte_enable,
	input if_mem_resp,
	input lc3b_word if_mem_rdata,
	output if_memread,
	
	/* MEM memory signals*/
	output lc3b_word mem_memaddr,
	output logic[1:0] mem_mem_byte_enable,
	input mem_mem_resp,
	input lc3b_word mem_mem_rdata,
	output logic mem_memread,
	output lc3b_word mem_mem_wdata,
	output logic mem_memwrite

);



pipeline_datapath the_pip(
	 .clk(clk),
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


endmodule: DGM 