module dirtyselect_l2(
	input dirty0,
	input dirty1,
	input lru,
	output logic dirty
);

always_comb
begin
	dirty = 0;
	case(lru)
		1'b0:
			dirty = dirty0;
		1'b1:
			dirty = dirty1;
	endcase
end

endmodule : dirtyselect_l2