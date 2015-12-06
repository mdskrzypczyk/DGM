import lc3b_types::*;

/**
 * the BTB module which contains both datapath and control 
 */
 
module BTB(
	input clk,
	input lc3b_word pc_in, //pc value from IF stage 
	input lc3b_ipacket ipacket_in, //ipacket from resolve stage, contain the pc 
	input lc3b_ipacket if_packet_in, //ipacket from IF stage 
	input lc3b_word pc_target, //the pc target from resolve stage, which used to update the target array 
	input logic branch_resolve, //the resolved branch 
	
	output logic stall, //stall logic for btb controller 
	
	output logic tag_hit,	//tag hit goes into ipacket creater 
	output lc3b_pc_ways ways, //ways offset when BTB hit 
	output lc3b_word pc_tar,	//target pc goes into pcmux 
	output logic taken_prediction	//branch taken goes into pcmux 
);

/* internal signals */
logic load_tag, load_target, load_valid, lru_store, load_lru;
logic load_btb;
logic load_bht, clear_bht;
logic clear_target_holder;


btb_datapath DATAPATH (
	.clk(clk),
	.pc_in(pc_in),
	.load_tag(load_tag),
	.load_target(load_target),
	.load_lru(load_lru),
	.load_valid(load_valid),
	.lru_store(lru_store),
	.ipacket_in(ipacket_in),
	.if_packet(if_packet_in),
	.pc_target(pc_target),
	.br_result(branch_resolve),
	.clear_bht(clear_bht),
	.load_bht(load_bht),
	.clear_target_holder(clear_target_holder),

	.ways(ways),	
	.load_btb(load_btb),
	.tag_hit(tag_hit),
	.pc_tar(pc_tar),
	.taken_prediction(taken_prediction)
	
);

btb_control CONTROL(
	.clk(clk),
//	.tag_hit(tag_hit),
	.load_btb(load_btb),
	.clear_target_holder(clear_target_holder),
	
	.stall(stall), //the stall logic from btb controller 
	
	.load_tag(load_tag),
	.load_target(load_target),
	.load_valid(load_valid),
	.lru_store(lru_store),
	.load_lru(load_lru)
);

bht_control BHT_CONTROL(
	.packet_in(ipacket_in),
	.load_bht(load_bht),
	.clear_bht(clear_bht)
);

endmodule: BTB 