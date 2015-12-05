import lc3b_types::*;
module tag_array_l2
(
	input clk,
	input load,
	input lc3b_tag_l2 tag,
	input lc3b_set_l2 set,
	input lru,
	output lc3b_tag_l2 tag_out0,
	output lc3b_tag_l2 tag_out1
);

/* L2 cache is set as 32 sets of cache lines*/
lc3b_tag_l2 tag0 [31:0] /* synthesis ramstyle = "logic" */;
lc3b_tag_l2 tag1 [31:0] /* synthesis ramstyle = "logic" */;

initial
begin
	for(int i = 0; i < $size(tag0); i++)
	begin
		tag0[i] = 6'b0;
		tag1[i] = 6'b0;
	end
end

always_ff @ (posedge clk)
begin
	if (load == 1)
	begin
		case(lru)
			1'b0: begin
				tag0[set] = tag;
			end
			1'b1: begin
				tag1[set] = tag;
			end
		endcase
	end
end

always_comb
begin
	tag_out0 = tag0[set];
	tag_out1 = tag1[set];
end

endmodule : tag_array_l2
