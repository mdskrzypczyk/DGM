import lc3b_types::*;

module twobitarray
(
	input clk,
	input load,
	input clear,
	input tag0_hit,
	input tag1_hit,
	input lru,
	input lc3b_set set,
	output logic outbit0,
	output logic outbit1
);

logic bit0 [7:0];
logic bit1 [7:0];

initial
begin
	for(int i = 0; i < $size(bit0); i++)
	begin
		bit0[i] = 0;
		bit1[i] = 0;
	end
end

always_ff @ (posedge clk)
begin
	if (load == 1)
	begin
		if(tag0_hit)
			bit0[set] = 1;
		else if(tag1_hit)
			bit1[set] = 1;
		else
		begin
			case(lru)
				1'b0: begin
					bit0[set] = 1;
				end	
				1'b1: begin
					bit1[set] = 1;
				end
			endcase
		end
	end
	if (clear == 1)
	begin
		if (tag0_hit)
			bit0[set] = 0;
		else if(tag1_hit)
			bit1[set] = 0;
		else
		begin
			case(lru)
				1'b0 : begin
					bit0[set] = 0;
				end
				1'b1 : begin
					bit1[set] = 0;
				end
			endcase
		end
	end
end

always_comb
begin
	outbit0 = bit0[set];
	outbit1 = bit1[set];
end

endmodule : twobitarray