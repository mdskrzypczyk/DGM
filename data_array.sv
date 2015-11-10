import lc3b_types::*;
module data_array
(
	input clk,
	input load,
	input lru,
	input tag0_hit,
	input tag1_hit,
	input lc3b_burst in,
	input lc3b_set set,
	output lc3b_burst cache_out1,
	output lc3b_burst cache_out2
);

lc3b_burst way0 [7:0] /* synthesis ramstyle = "logic" */;
lc3b_burst way1 [7:0] /* synthesis ramstyle = "logic" */;

initial
begin
	for (int i = 0; i < $size(way0); i++)
	begin
		way0[i] = 128'b0;
		way1[i] = 128'b0;
	end
end

always_ff @ (posedge clk)
begin
	if(load == 1)
	begin
		if(tag0_hit)
			way0[set] = in;
		else if(tag1_hit)
			way1[set] = in;
		else
		begin
			case(lru)
				1'b0: begin
					way0[set] = in;
				end
				1'b1: begin
					way1[set] = in;
				end
			endcase
		end
	end
end

always_comb
begin
	cache_out1 = way0[set];
	cache_out2 = way1[set];
end

endmodule : data_array