import lc3b_types::*;

module shiftdown
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
			out = {8'h0, in[15:8]};
		else
			out = {8'h0, in[7:0]};
	end
	else
	begin
		out = in;
	end
end
endmodule : shiftdown