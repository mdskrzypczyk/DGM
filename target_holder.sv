import lc3b_types::*;


/**
 * target_holder:
 * 			the module which hold the brach target and pc tag for loading stage 
 *	it load in when load_btb signal is high 
 *   it clears the signal when in loading stage 
 */
 
 
 module target_holder(
			input clk, 
			input load, //load signal 
			input clear, //clear signal 
			input lc3b_pc_tag pc_load, //the pc tag for loading 
			input lc3b_set pc_load_set, //the pc load set 
			input lc3b_word pc_target, //the target pc for loading 
			
			output lc3b_pc_tag pc_load_out, 
			output lc3b_set pc_load_set_out,
			output lc3b_word pc_target_out 
 
 );
 
 /* register to hold those values */
 lc3b_pc_tag pc_tag;
 lc3b_word target_pc; 
 lc3b_set set;
 
 /* initiation */
 initial 
 begin 
		pc_tag = 10'b0;
		target_pc = 16'b0;
		set = 4'b0;
 end 
 
 
 always_ff @ (posedge clk)
 begin 
		if(load)
			begin 
				pc_tag = pc_load;
				target_pc = pc_target;
				set = pc_load_set;
			end 
		if(clear)
			begin 
				pc_tag  = 10'b0;
				target_pc = 16'b0;
				set = 4'b0;
			end 
 end 
 
 always_comb
 begin 
		pc_load_out = pc_tag;
		pc_target_out = target_pc;
		pc_load_set_out = set;
 end 
 
 
 endmodule: target_holder