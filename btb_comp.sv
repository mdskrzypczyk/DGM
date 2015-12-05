import lc3b_types::*;

/**
 * The tag compare module for BTB 
 * it takes in four tags from pc_array, and the current pc tag
 * it output four tag hits signal and final final hit signal 
 */
 
module btb_comp(
	input lc3b_pc_tag tag,
	input lc3b_pc_tag tag0, tag1, tag2, tag3,
	input logic branch, //indicate this is a branch 
	input logic valid0, valid1, valid2, valid3,
	
	output lc3b_pc_ways ways, //2 bit ways index 
	output logic tag_hit,
	output logic tag0_hit, tag1_hit, tag2_hit, tag3_hit

);

always_comb 
begin 
	tag_hit = 0;
	tag0_hit = 0;
	tag1_hit = 0;
	tag2_hit = 0;
	tag3_hit = 0;
	ways = 2'b00;
	
	if(tag == tag0 && valid0 && branch)
	begin 
		tag_hit = 1;
		tag0_hit = 1;
		ways = 2'b00;
	end 
	else if(tag == tag1 && valid1 && branch)
	begin 
		tag_hit = 1;
		tag1_hit = 1;
		ways = 2'b01;
	end 
	else if(tag == tag2 && valid2 && branch)
	begin 
		tag_hit = 1;
		tag2_hit = 1;
		ways = 2'b10;
	end 
	else if(tag == tag3 && valid3 && branch)
	begin 
		tag_hit = 1;
		tag3_hit = 1;
		ways = 2'b11;
	end 
	
	
end 


endmodule: btb_comp