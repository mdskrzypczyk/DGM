import lc3b_types::*;

/* the or gate module */

module OR #(parameter width = 16)
(
	input [width-1:0] a,b,
	output logic [width-1:0] f
);

	assign f = (a || b);

endmodule: OR