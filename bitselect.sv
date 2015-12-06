module bitselect
(
	input sel0,
	input sel1,
	input lru,
	input data0,
	input data1,
	output logic out
);

always_comb
begin
	out = 0;
	if(sel0 == 1)
		out = data0;
	else if (sel1 == 1)
		out = data1;
	else
	begin
		case(lru)
			1'b0:
				out = data0;
			1'b1:
				out = data1;
		endcase
	end
end


endmodule : bitselect