import lc3b_types::*;

/**
 * The pc select module which replace the old pc mux 
 * the new pc select module takes in a new input which indicate 
 * in this cycle it loads the pc target from branch prediction 
 */
 
 module pc_select(
	input logic[1:0] pcmux_sel, //the old pcmux select 
	input lc3b_word plus2_out, //pc+2
	input lc3b_word wb_data, //jumping address from resolve stage 
	input lc3b_word br_add, //branching address for BR instructions 
//	input lc3b_word pc_target, //the target pc from target register 
//	input logic predict_taken, //the prediction is taken 
	
	output lc3b_word pcmux_out //the output pc value 
 
 );
 
 always_comb
 begin 
	pcmux_out = 16'b0;
//	if(predict_taken)
//		pcmux_out = pc_target;
//	else 
//		begin 
			case(pcmux_sel)
				2'b00:	pcmux_out = plus2_out;
				2'b01:	pcmux_out = wb_data;
				2'b10:	pcmux_out = br_add;
				2'b11:	pcmux_out = 16'b0;
			endcase
//		end
 end 
 
 
 endmodule: pc_select