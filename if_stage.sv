import lc3b_types::*;

module if_stage
(
	input clk,
	input lc3b_word br_add,
	input lc3b_word wb_data,
	input[1:0] pcmux_sel,
	input pc_stall,
	
	output lc3b_ipacket packet,
	
	// temporary output signals for memory module 
	//output signal to memory 
	output lc3b_word if_memaddr,	//address
	output logic if_memread,	//read
	output logic [1:0] if_mem_byte_enable, //byte read 
	//no write and write data 

	
	//input signal from memory 
	input if_mem_resp,	//mem response 
	input lc3b_word if_mem_rdata	//read data 
	
);

/*internal signals*/
lc3b_word pcmux_out, pc_out,  plus2_out;
logic load_pc;
 

/* PC PLUS 2 UNIT */
plus2 plus2(
	.in(pc_out),
	
	.out(plus2_out)
);

/* LOAD PC MUX */
mux4 #(.width(16)) pcmux  
(
	.sel(pcmux_sel),
	.a(plus2_out),
	.b(wb_data),
	.c(br_add),
	.d(16'h0),				//USEABLE SPACE
	
	.f(pcmux_out)
);



/* PC Register */
register pc_module
(
	.clk(clk),
	.load(~pc_stall),
	.in(pcmux_out),
	
	.out(pc_out)
); 

/* Ipacket Generator */
ipacket_creator ipacket_creator 
(
	.inst(if_mem_rdata),
	.pc(pc_out),
	
	.ipacket(packet)
);

/* Load Logic for PC */
pc_load_logic pc_load_logic
(
	.in(1'b0),
	.load_pc(load_pc)
);

/* Assign memory signals */
 assign if_memaddr = pc_out;
 assign if_memread = 1'b1;
 assign if_mem_byte_enable = 2'b11;

endmodule : if_stage