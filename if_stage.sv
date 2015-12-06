import lc3b_types::*;

module if_stage
(
	input clk,
	input lc3b_word br_add,
	input lc3b_word wb_data,
	input logic[1:0] pcmux_sel,
	input logic pc_stall,
	input logic tag_hit, //the tag hit from BTB
	input lc3b_pc_ways ways, //ways offset from BTB 
	input logic flush, //flushing signal 
	input lc3b_word flush_pc, //the pc value after flush
	input logic br_taken,
	
	input lc3b_word pc_tar, //the pc target 
	input taken_prediction, //the branch prediction bit 
	input lc3b_ipacket br_packet, //the packet from next stage contain prediction information 
	
	output lc3b_ipacket packet,
	output lc3b_word if_pc, //currently use the pcmux output, not the pc module output 
	
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

assign if_pc = pcmux_out;

 

/* PC PLUS 2 UNIT */
plus2 plus2(
	.in(pc_out),
	
	.out(plus2_out)
);

pc_select pcmux(
	.pcmux_sel(pcmux_sel),
	.plus2_out(plus2_out),
	.wb_data(wb_data),
	.br_add(br_add),

	
	.pcmux_out(pcmux_out)
);



pc_module PC_MODULE(
	.clk(clk),
	.load(~pc_stall),
	.pcmux_out(pcmux_out),
	.pc_predict(pc_tar),
	.flush_pc(flush_pc),
	.br_sig(br_taken),
	.flush(flush),
	.prediction_taken(taken_prediction),
	
	.out(pc_out)
);


/* Ipacket Generator */
ipacket_creator ipacket_creator 
(
	.inst(if_mem_rdata),
	.pc(pc_out),
	.tag_hit(tag_hit),
	.ways(ways),
	.target_pc(pc_tar),
	.br_prediction(taken_prediction),
	
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
