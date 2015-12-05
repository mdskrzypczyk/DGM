import lc3b_types::*;

/**
 * the module to store target jumping pc value for BTB
 *  The target array stores the target pc value 
 * it only load in the resolved stage, and read in the IF stage 
 */
 
module target_array(
	input clk,
	input load,
	input tag0_hit, tag1_hit, tag2_hit, tag3_hit,
	input lc3b_word in, //target pc value input from the resolved stage 
	input lc3b_pc_ways btb_lru, 
	input lc3b_set load_set, read_set, //the set number for both loading and reading 
	output lc3b_word target0_pc, target1_pc, target2_pc, target3_pc
);

/* the BTB size contain 4 ways and 16 sets */
lc3b_word target0[15:0];
lc3b_word target1[15:0];
lc3b_word target2[15:0];
lc3b_word target3[15:0];

initial 
begin 
	for (int i = 0; i < $size(target0); i++)
	begin 
		target0[i] = 16'b0;
		target1[i] = 16'b0;
		target2[i] = 16'b0;
		target3[i] = 16'b0;
	end 
end 


/* loading the array when load signal is high*/
always_ff @ (posedge clk)
begin 
	if(load == 1) //case loading, since dont have write back just need to follow lru 
	begin 
		case(btb_lru)
			2'b00:	target0[load_set] = in;
			2'b01:	target1[load_set] = in;
			2'b10:	target2[load_set] = in;
			2'b11:	target3[load_set] = in;
		endcase
	end 
end 

always_comb
begin 
	target0_pc = target0[read_set];
	target1_pc = target1[read_set];
	target2_pc = target2[read_set];
	target3_pc = target3[read_set];
end 


endmodule: target_array
