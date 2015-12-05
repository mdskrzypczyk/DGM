import lc3b_types::*;
module alg_unit(
	input clk,
	input lc3b_word opA, opB,
	input [2:0] op_x_bits,
	output logic done,
	output lc3b_word hi_bits, lo_bits
);

logic [2:0] cycle_count;
logic [31:0] mul;

mult16 multiplier(
	.clock(clk),
	.dataa(opA),
	.datab(opB),
	.result(mul)
);

initial
begin
	cycle_count = 3'b011;
end

always_ff @ (posedge clk)
begin
	case(op_x_bits)
		op_mul :
		begin
			if(cycle_count == 0)
				cycle_count = 3'b011;
			else
				cycle_count = cycle_count - 3'b001;	
		end
		default : ;
	endcase
end

always_comb
begin
	done = 1'b0;
	hi_bits = 16'h0;
	lo_bits = 16'h0;
	case(op_x_bits)
		op_mul: begin
			hi_bits = mul[31:16];
			lo_bits = mul[15:0];
		end
		default : done = 1'b1;
	endcase
	
	if(cycle_count == 3'b000)
		done = 1'b1;
end

endmodule : alg_unit