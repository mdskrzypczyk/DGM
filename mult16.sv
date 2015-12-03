module mult16(
	input signed [15:0] a, b,
	output signed [31:0] f
);

assign f = a*b;

endmodule : mult16