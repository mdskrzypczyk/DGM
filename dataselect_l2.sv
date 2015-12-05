import lc3b_types::*;
module dataselect_l2
(
	input sel0,
	input sel1,
	input lru,
	input lc3b_burst data0,
	input lc3b_burst data1,
	output lc3b_burst out
);

always_comb
begin
	out = 256'b0;
	if(sel0 == 1)
		out = data0;
	else if (sel1 == 1)
		out = data1;
	else
	case(lru)
		1'b0:
			out = data0;
		1'b1:
			out = data1;
	endcase
end

endmodule : dataselect_l2