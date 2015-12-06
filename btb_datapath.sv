import lc3b_types::*;


/**
 * The 4 way set associative BTB 
 * Input : 
 * 	the current pc value 
 * output :
 * 	the target pc value if it is a branch 
 *		the prediction for the branch 
 *		currently only support BRnzp instruction 
 */
 
 module btb_datapath(
	input clk, 
	input lc3b_word pc_in, //the input pc value 
	input load_tag, 
	input load_target,
	input load_lru,
	input load_valid,
	input lru_store,
	input lc3b_ipacket ipacket_in, // the ipacket input to check the resolved branch instruction 
	input lc3b_ipacket if_packet, //the ipacket from if stage 
	input lc3b_word pc_target, //the target jumping pc in resolved stage 
	input logic br_result, //the brach result from resolving stage 
	input logic clear_bht, load_bht, //bht control signals
	input logic clear_target_holder, //the signal to clear the target holder 
	
	output lc3b_pc_ways ways,
	output logic  load_btb,
	output logic tag_hit,
	output lc3b_word pc_tar, //the target pc value 
	output logic taken_prediction //the branch prediction, 1 for taken 0 for not taken 
	
 );
 
 /* internal signals */
 logic tag0_hit, tag1_hit, tag2_hit, tag3_hit;
 lc3b_pc_ways btb_lru;
 lc3b_pc_tag pc_out0, pc_out1, pc_out2, pc_out3;
 lc3b_word target0_pc, target1_pc, target2_pc, target3_pc;
 
 logic clear_valid;
 logic valid0, valid1, valid2, valid3;
 logic br0, br1, br2, br3;
 
 lc3b_pc_tag pc_load_out;
 lc3b_set pc_load_set_out;
 lc3b_word pc_target_out;
 

 /* the array store pc tags */
 /* only load in the resolved stage, read in the IF stage */
 pc_array PC_ARRAY(
	.clk(clk),
	.load(load_tag),
	.pc_load(pc_load_out), // the pc tag for loading, from resolved stage 
	.load_set(pc_load_set_out), //the set from pc in resovled stage 
	.read_set(pc_in[3:0]), // the set from pc in IF stage 
	.btb_lru(btb_lru),
	.pc_out0(pc_out0),
	.pc_out1(pc_out1),
	.pc_out2(pc_out2),
	.pc_out3(pc_out3)
 
 );
 
 
 /* btb compare module, which compare the 4 tags for pc */
 btb_comp BTB_COMP(
	.tag(pc_in[15:4]),
	.tag0(pc_out0),
	.tag1(pc_out1),
	.tag2(pc_out2),
	.tag3(pc_out3),
	.valid0(valid0),
	.valid1(valid1),
	.valid2(valid2),
	.valid3(valid3),
	.branch(if_packet.branch),
	.tag_hit(tag_hit),
	.ways(ways),
	.tag0_hit(tag0_hit),
	.tag1_hit(tag1_hit),
	.tag2_hit(tag2_hit),
	.tag3_hit(tag3_hit)
 );
 
 /* the target jumping array */
 target_array TARGET_ARRAY(
	.clk(clk),
	.load(load_target),
	.tag0_hit(tag0_hit), 
	.tag1_hit(tag1_hit), 
	.tag2_hit(tag2_hit), 
	.tag3_hit(tag3_hit),
	.in(pc_target_out),
	.btb_lru(btb_lru),
	.load_set(pc_load_set_out), //the set from pc in resovled stage 
	.read_set(pc_in[3:0]), // the set from pc in IF stage 
	.target0_pc(target0_pc),
	.target1_pc(target1_pc),
	.target2_pc(target2_pc),
	.target3_pc(target3_pc)
 );
 
 /* the target selecting module */
 target_sel TARGET_SEL(
	.target0(target0_pc),
	.target1(target1_pc),
	.target2(target2_pc),
	.target3(target3_pc),
	.tag0_hit(tag0_hit),
	.tag1_hit(tag1_hit),
	.tag2_hit(tag2_hit),
	.tag3_hit(tag3_hit),
	.pc_target(pc_tar)
	
 );
 
 /* the register to hold targets for 1 cycle */
 target_holder HOLDER(
	.clk(clk),
	.load(load_btb),
	.clear(clear_target_holder),
	.pc_load(ipacket_in.pc[15:4]), //holding for pc tag
	.pc_load_set(ipacket_in.pc[3:0]), //holding for pc set 
	.pc_target(pc_target),	//holding for pc target 
	
	.pc_load_out(pc_load_out),
	.pc_load_set_out(pc_load_set_out),
	.pc_target_out(pc_target_out)
 );
 
 
 
 /* the valid array which indicate the pc way is valid */
 fourbitarray valid_array(
	.clk(clk),
	.load(load_valid),
	.clear(clear_valid),
	.btb_lru(btb_lru),
	.load_set(pc_load_set_out), //the set from pc in resovled stage 
	.read_set(pc_in[3:0]), // the set from pc in IF stage 
	.outbit0(valid0),
	.outbit1(valid1),
	.outbit2(valid2),
	.outbit3(valid3)
	
 );
 
 /* the lru logic for btb */
 btb_lru BTB_LRU(
	.clk(clk),
	.load(load_lru),
	.tag0_hit(tag0_hit),
	.tag1_hit(tag1_hit),
	.tag2_hit(tag2_hit),
	.tag3_hit(tag3_hit),
	.store(lru_store),
	.set(pc_in[3:0]),
	.btb_lru_out(btb_lru) //btb lru only used in the loading situation. 
 );
 
 /* btb loading module */
 btb_load BTB_LOAD(
	.ipacket(ipacket_in),
	.load_btb(load_btb)
 );
 
 
 /* BHT the branch history table */
 BHT BHT_module(
	.clk(clk),
	.load(load_bht),
	.clear(clear_bht),
	.br_result(br_result),
	.btb_lru(btb_lru), //ways offset when loading and miss 
	.load_set(ipacket_in.pc[3:0]), //loading happens in the resolving stage 
	.read_set(pc_in[3:0]), //rading happens in the IF stage 
	.ways(ipacket_in.ways),	//ways offset when loading and hit 
	
	.br0(br0),
	.br1(br1),
	.br2(br2),
	.br3(br3)
 );
 
 
 /* the branch prediction select module */
 br_select branch_select_module(
	.br0(br0),
	.br1(br1),
	.br2(br2),
	.br3(br3),
	.tag0_hit(tag0_hit),
	.tag1_hit(tag1_hit),
	.tag2_hit(tag2_hit),
	.tag3_hit(tag3_hit),
	
	.br_predict(taken_prediction)
 );
 
 
 endmodule: btb_datapath