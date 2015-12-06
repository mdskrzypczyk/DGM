import lc3b_types::*;

/**
 * The br_select module 
 * 	which select the branch prediction based on the tag hit 
 */
 
 module br_select(
	input logic br0, br1, br2, br3,
	input logic tag0_hit, tag1_hit, tag2_hit, tag3_hit,
	output logic br_predict 
 );
 
 
 always_comb
 begin 
	br_predict = 1'b0; //predict not taken as default  
	if(tag0_hit)
		br_predict = br0;
	if(tag1_hit)
		br_predict = br1;
	if(tag2_hit)
		br_predict = br2;
	if(tag3_hit)
		br_predict = br3;
 end 
 
 
 endmodule: br_select