

/**
 * The BTB control logic 
 * which controls the btb operation
 */
 
 module btb_control(
	input clk,
//	input tag_hit,	//from btb which indicate there is a hit
	input load_btb, //from other module which indicate need to load 
	
	output logic load_tag,
	output logic load_target,
	output logic load_valid,
	output logic lru_store,
	output logic stall, 
	output logic clear_target_holder,
	output logic load_lru
 
 );
 
/* in current solution, the BTB will have 1 cycle penalty when miss hit , which the entire pipeline will be stalled for 1 cycle */
 
 enum int unsigned {
	btb_access,	//contain both hit and miss situation 
	btb_load	//when a branch is taken and need to load into btb
 }state, nextstate;
 
 // btb singal controls 
 always_comb
 begin : state_actions
	load_tag = 0;
	load_target = 0;
	load_lru = 0;
	load_valid = 0;
	lru_store = 0;
	stall = 0;
	clear_target_holder = 0;
	
	case(state)
		btb_access:
			begin 
			//access stage do nothing, only load in the loading stage 

			end 
			
		btb_load: //when there is a miss, and loading the instruction in the resolving stage 
			begin 
				load_tag = 1'b1;
				load_target = 1'b1;
				load_valid = 1'b1;
				load_lru = 1'b1;
				lru_store = 1'b1;
				clear_target_holder= 1'b1;
			end 
	endcase
 end 
 
 // btb state transitions 
 always_comb
 begin :next_state_logic 
	nextstate = state;
	case(state)
		btb_access:
		begin 
			if(load_btb)
				nextstate = btb_load;
		end 
		
		btb_load:
		begin 
			nextstate = btb_access;
		end 
	endcase
 end 
 
 always_ff @ (posedge clk)
 begin :next_state_assignment
	state <= nextstate;
 end 
 
 
 endmodule: btb_control