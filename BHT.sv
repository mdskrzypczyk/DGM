import lc3b_types::*;


/**
 * The Branch History Table 
 * 	The BHT matches with the BTB which it is 4 way 16 sets 
 *
 * The Branch History Table gives prediction for prach as following
 * 	TT: T
 * 	NT: T
 *		TN: N
 * 	NN: N
 * 	The initial value for BHT is TT 
 *
 * The BHT only load at the branch resolving stage 
 * BHT gives out prediction when there is a hit, and prediction at IF stage 
 * BHT clears when new loading in BTB in resolving stage 
 */ 
 
 module BHT(
		input clk,
		input logic load, //loading with BR prediction 
		input logic clear, //the clear logic when loading new branches 
		input logic br_result, //the branch result going into the BHT 
		input lc3b_pc_ways btb_lru, //the way select when change 
		input lc3b_set load_set, read_set, //the set number index  
		input lc3b_pc_ways ways, //the ways select from ipacket when hit 
		
		
		output logic br0, br1, br2, br3 //the prediction for 4 ways   
 );
 
 /* the BHT contain 4 ways and 16 sets, using single bit to represent */
 logic[1:0] history0[15:0];
 logic[1:0] history1[15:0];
 logic[1:0] history2[15:0];
 logic[1:0] history3[15:0];
 
 /* initialization */
 initial 
 begin 
	for(int i = 0; i < $size(history0); i++)
	begin 
		history0[i] = 2'b11;
		history1[i] = 2'b11;
		history2[i] = 2'b11;
		history3[i] = 2'b11;
	end 
 end 
 
 /* loading or changing the BHT */
 always_ff @ (posedge clk)
 begin 
	//loading and there is a hit on BTB side 
	if(load && clear == 1'b0 ) 
	begin 
		case(ways) //each one has it's own case to update 
			2'b00:
				case(history0[load_set])
					2'b00: history0[load_set] = 2'b00;
					2'b01: history0[load_set] = 2'b11;
					2'b10: history0[load_set] = 2'b00;
					2'b11: history0[load_set] = 2'b11;
				endcase
			2'b01:
				case(history1[load_set])
					2'b00: history1[load_set] = 2'b00;
					2'b01: history1[load_set] = 2'b11;
					2'b10: history1[load_set] = 2'b00;
					2'b11: history1[load_set] = 2'b11;
				endcase
			2'b10:
				case(history2[load_set])
					2'b00: history2[load_set] = 2'b00;
					2'b01: history2[load_set] = 2'b11;
					2'b10: history2[load_set] = 2'b00;
					2'b11: history2[load_set] = 2'b11;
				endcase
			2'b11: 
				case(history3[load_set])
					2'b00: history3[load_set] = 2'b00;
					2'b01: history3[load_set] = 2'b11;
					2'b10: history3[load_set] = 2'b00;
					2'b11: history3[load_set] = 2'b11;
				endcase
		endcase
	end 
	
	//loading a new one 
	if(load && clear == 1'b1) 
	begin 
		case(btb_lru)
			2'b00:	history0[load_set] = 2'b11;
			2'b01:	history1[load_set] = 2'b11;
			2'b10:	history2[load_set] = 2'b11;
			2'b11:	history3[load_set] = 2'b11;
		endcase
	end 
	
 end 
 
 /* combinational logic to output data constantly */
always_comb 
begin 
	br0 = history0[read_set][0];
	br1 = history1[read_set][0];
	br2 = history2[read_set][0];
	br3 = history3[read_set][0];
end  
 
 
 
 endmodule: BHT
 
 
 
 
 
 
 