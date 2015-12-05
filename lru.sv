import lc3b_types::*;
module lru
(
	input clk,
	input load,
	input tag0_hit,
	input tag1_hit,
	input lc3b_set set,
	output logic lru_out
);

/* lru bits changed to 16 bits for increasing cache size */
logic lru_bits[15:0];

initial
begin
	for(int i = 0; i < $size(lru_bits); i++)
	begin
		lru_bits[i] = 0;
	end	
end

always_ff @ (posedge clk)
begin
	if(load == 1)
	begin
		if(tag0_hit)
			lru_bits[set] = 1;
		else if (tag1_hit)
			lru_bits[set] = 0;
	end
end

always_comb
begin
	lru_out = lru_bits[set];
end

endmodule : lru
