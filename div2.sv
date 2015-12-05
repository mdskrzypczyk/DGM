import lc3b_types::*;

/* Divide by 2 operation */

module div2 #(parameter width = 16)
(
	input [width-1:0] in,
	output [width-1:0] out 
);

assign out = $unsigned(in >> 1);


endmodule: div2