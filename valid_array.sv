
/**
 *	The Valid bit Array, contains two sets of valid bits, which tells the corresponding cache lines 
 * is valid for not. if the valid bit is 1 means the cache line is valid and contains information from 
 * memory, if the valid bit is 0, means the cache line is not being used and do not contain memory 
 * information 
 */
 
 module valid_array(
	input clk,
	input load, 	//case when loading 1 into the valid bit slot 
	input[2:0] set_sel,	//selecting a specific set to operating on 
	input tag_sel,		//select 1 out of 2 ways to oeprating on 
	
	output logic v0, v1, 
	output logic valid_sig	//the current valid bit in that slot 
 );
 
 
//define data structure for each way 
	logic way0[7:0];
	logic way1[7:0];
 
	
 
 //initialization for the valid bit array -- starting with non-valid 
 initial
 begin 
		for(int i = 0; i < $size(way0); i++)
			begin 
				way0[i] = 1'b0;
				way1[i] = 1'b0;
			end 
 end 
 
 //operating when log signal is high 
 always_ff @(posedge clk)
	begin 
		if(load == 1)//case the slot is being used by memory 
			begin 
				case(tag_sel) //select which way it is operating on 
					
					1'b0: //loading into way0
						begin 
							way0[set_sel] = 1'b1;
						end 
					1'b1: //loading into way1
						begin 
							way1[set_sel] = 1'b1;
						end 
					
				endcase 
			end 
	end 
 
 //output valid bit information 
 always_comb
	begin 
		case(tag_sel) //select which way it is outputing on 
			1'b0: begin //output way0
				v0 = way0[set_sel];
				v1 = way1[set_sel];
				valid_sig = way0[set_sel];
			end 
			1'b1: begin //output way1
				v0 = way0[set_sel];
				v1 = way1[set_sel];
				valid_sig = way1[set_sel];
			end 
		endcase
	end 
 
 
 endmodule: valid_array