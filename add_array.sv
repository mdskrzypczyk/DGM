import lc3b_types::*;

/**
 *	The set of Address Array. which contains the address corresponding to cache data
 */
 
 module add_array(
	input clk,
	input load, //loading the cache address 
	input lc3b_word in, //input address 
	input[2:0] set_sel, //the set select 
	input line_sel, //1 bit select a line in the set 
	
	output lc3b_word out 
 );
 
 
 //define data structure for each way	
	//each way contains 8 set 
	lc3b_word way0[7:0];
	lc3b_word way1[7:0];
 

 //initial values for all cache lines 
	initial 	
	begin 
		for(int i = 0; i < $size(way0); i++)
			begin 
				way0[i] = 16'b0;
				way1[i] = 16'b0; 
			end 
	end 
	

 //operation on loading address 
	always_ff @(posedge clk)
	begin 
		if(load == 1) //case when it is loading the address 
			begin 
					case(line_sel) //select the line/way it is operating on 

					1'b0:	way0[set_sel] = in;
					1'b1: way1[set_sel] = in;
					
					endcase
			end 		
	end 

 //combination logic to output the correct address for write back 
	always_comb
	begin 
		case(line_sel)
			1'b0:	out = way0[set_sel];
			1'b1: out = way1[set_sel];
		endcase
	end 
	
	
	
	

endmodule: add_array