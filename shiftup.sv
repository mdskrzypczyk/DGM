import lc3b_types::*;

module shiftup
(
	input shift,
	input byte_op,
	input lc3b_word in,
	output lc3b_word out
);

always_comb
begin
	if(byte_op)
	begin
		if (shift)
			out = {in[7:0], 8'h0};
		else
			out = in;
	end
	else
	begin
		out = in;
	end
end
endmodule : shiftup