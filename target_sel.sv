import lc3b_types::*;

/**
 * The target select module, which takes in four target pc 
 * according to the compare module, and select the correct
 * pc target as output 
 */
 
module target_sel(
	input lc3b_word  target0, target1, target2, target3,
	input logic tag0_hit, tag1_hit, tag2_hit, tag3_hit,
	output lc3b_word pc_target 
);

/* combinational logic output target pc, 4 way mux */

always_comb
begin 
	pc_target = 16'b0; //default value all zeros 
	if(tag0_hit)
		pc_target = target0;
	if(tag1_hit)
		pc_target = target1;
	if(tag2_hit)
		pc_target = target2;
	if(tag3_hit)
		pc_target = target3;
end 



endmodule: target_sel