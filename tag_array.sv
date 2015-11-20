import lc3b_types::*;
module tag_array
(
	input clk,
	input load,
	input lc3b_tag tag,
	input lc3b_set set,
	input lru,
	output lc3b_tag tag_out0,
	output lc3b_tag tag_out1
);


/* change array size into 16 entries for increasing cache size */
lc3b_tag tag0 [15:0] /* synthesis ramstyle = "logic" */;
lc3b_tag tag1 [15:0] /* synthesis ramstyle = "logic" */;

initial
begin
	for(int i = 0; i < $size(tag0); i++)
	begin

		tag0[i] = 8'b0;
		tag1[i] = 8'b0;
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

endmodule : tag_array
