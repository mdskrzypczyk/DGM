module div16(
	input signed [15:0] a, b,
	output signed [15:0] f, rem
);

assign f = a/b;
assign rem = a%b;

endmodule : div16