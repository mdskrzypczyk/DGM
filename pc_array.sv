import lc3b_types::*;

/**
 * The pc array, which store the pc values for the BTB 
 * The BTB is 4 way 16 sets associative cache 
 * first 2 bits of pc are covered for 4 ways 
 * next 4 bits of the pc are used for set selection
 * rest 10 bits are used for tag bits  
 */
 
module pc_array(
	input clk,
	input load,//signal to load new pc
//	input lc3b_pc_tag pc,	// current pc tag, total of 10 bits 
	input lc3b_pc_tag pc_load, //the pc tag for loading 
	input lc3b_set load_set, read_set, // 4 bits set index for both loading and read 
	input lc3b_pc_ways btb_lru,			//lru number indicate which way to change 
	output lc3b_pc_tag pc_out1, pc_out2, pc_out3, pc_out0 	//four output pc 

);

/* the four way set associative array to store incoming pc values */
lc3b_pc_tag pc0 [15:0]; //each array contains total of 15 sets 
lc3b_pc_tag pc1 [15:0]; //each array contains total of 15 sets 
lc3b_pc_tag pc2 [15:0]; //each array contains total of 15 sets 
lc3b_pc_tag pc3 [15:0]; //each array contains total of 15 sets 


initial 
begin 
	for(int i = 0; i < $size(pc0); i++)
	begin 
		pc0[i] = 10'b0;
		pc1[i] = 10'b0;
		pc2[i] = 10'b0;
		pc3[i] = 10'b0;
	end 
end 

always_ff @ (posedge clk)
begin 
	if(load == 1)
	begin 
		case(btb_lru)
			2'b00:	pc0[load_set] = pc_load; 
			2'b01:	pc1[load_set] = pc_load;
			2'b10:	pc2[load_set] = pc_load;
			2'b11:	pc3[load_set] = pc_load;
		endcase
	end 
	
end 

/* general combinational logic to output the pc */
always_comb
begin 
	pc_out0 = pc0[read_set];
	pc_out1 = pc1[read_set];
	pc_out2 = pc2[read_set];
	pc_out3 = pc3[read_set];
end 





endmodule: pc_array