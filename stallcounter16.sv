import lc3b_types::*;

module stallcounter16(
	input clk,
	input stall,
	output lc3b_word bubble_count
);

lc3b_word count_reg;

initial
begin
	count_reg = 16'h0;
end

always_ff @ (posedge clk)
begin
	if (stall)
		count_reg = count_reg + 16'h1;
end

always_comb
begin
	bubble_count = count_reg;
end

endmodule : stallcounter16