import lc3b_types::*;
module alg_unit(
	input lc3b_word opA, opB,
	input [2:0] op_x_bits,
	output lc3b_word hi_bits, lo_bits
);

logic [31:0] mul;
lc3b_word div_hi, div_lo;

mult16 multiplier(
	.a(opA),
	.b(opB),
	.f(mul)
);

div16 divider(
	.a(opA),
	.b(opB),
	.f(div_lo),
	.rem(div_hi)
);

always_comb
begin
	hi_bits = 16'h0;
	lo_bits = 16'h0;
	case(op_x_bits)
		op_mul: begin
			hi_bits = mul[31:16];
			lo_bits = mul[15:0];
		end
		op_div: begin
			hi_bits = div_hi;
			lo_bits = div_lo;
		end
		default:;
	endcase
end

endmodule : alg_unit