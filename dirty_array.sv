import lc3b_types::*;

/**
 *		The dirty array, contains two sets of dirty bits, and each bit indicate if the cache line 
 * is dirty or not. if the cache line is dirty, means it needs to write back when replace
 * if the cache line is not dirty, it means it does not need to be write back 
 */
 
 module dirty_array(
	input clk,
	input load, //loading and reset the dirty bit when changes 
	input clear, //clear and reset the dirty bit 
	input write, //writing signal which indicate this is a write operation 
	input[2:0] set_sel, //selecting which set it is operating on 
	input tag_sel,	//selecting which way it is operating on 

	output logic out //signle bit output for dirty value 
 );
 

//define data structure for each way 
	//each way contains 8 set 
	logic way0[7:0];
	logic way1[7:0];
	
 
 //initialization for the array 
	initial 
	begin 
		for(int i = 0; i < $size(way0); i++)
			begin 
				way0[i] = 1'b0;
				way1[i] = 1'b0;
			end 
	end 

 //on load/clear signal, changing the dirty bit in the array 
	always_ff @(posedge clk)
		begin 
			if(load == 1 && write == 1) //case change the dirty bit 
				begin 
					case(tag_sel)
						1'b0: way0[set_sel] = 1'b1;
						1'b1: way1[set_sel] = 1'b1;
					endcase
				end 
			if(clear) //case need to clear the dirty bit 
				begin 
					case(tag_sel)
						1'b0: way0[set_sel] = 1'b0;
						1'b1: way1[set_sel] = 1'b1;
					endcase
				end 
		end 
 
 //combination logic, which output the correct dirty bit value 
	always_comb
		begin 
			case(tag_sel)
				1'b0:	out = way0[set_sel];
				1'b1: out = way1[set_sel];				
			endcase
		end 
 
 
 endmodule: dirty_array 