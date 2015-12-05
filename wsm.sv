import lc3b_types::*;

/**
 *	The word split module 
 *		which takes in a 128 bits signal and split it into 8 words
 *	with each word contain 16 bits 
 */
 
 
module wsm(
	input[127:0] in,
	output[15:0] w1, w2, w3, w4, w5, w6, w7, w8
);

	always_comb begin 
		
		w1 = in[15:0];
		w2 = in[31:16];
		w3 = in[47:32];
		w4 = in[63:48];
		w5 = in[79:64];
		w6 = in[95:80];
		w7 = in[111:96];
		w8 = in[127:112];
		
	end 


endmodule:wsm