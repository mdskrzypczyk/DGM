import lc3b_types::*;

/**
 * the pc_module 
 * 	  the pc module is a more advanced register which support 
 * loading branch prediction values 
 */
 
 
 module pc_module (
	input clk, 
	input lc3b_word pcmux_out,
	input lc3b_word pc_predict, 
	input lc3b_word flush_pc, 
	input logic prediction_taken,
	input logic load, flush, br_sig, 
	
	output lc3b_word out 	
 );
 
 lc3b_word pc_value; //holding the pc value 
 
 //initilization 
 initial 
 begin 
	pc_value = 16'b0;
 end 
 
 always_ff @ (posedge clk)
 begin 
		if(load) //case loading 
			begin 
				if(prediction_taken && !flush )	//case when predict taking a branch 
					pc_value = pc_predict;
				else if(flush) //case when performing a flush 
					case(br_sig) 
						1'b1: //case it is taken 
							pc_value = pcmux_out;
						1'b0://case it is not taken
							pc_value = flush_pc;
					endcase
				else 
					pc_value = pcmux_out; 
			end 
 end 
 
 always_comb
 begin 
	out = pc_value;
 end 	
 
 
 
 
 endmodule: pc_module