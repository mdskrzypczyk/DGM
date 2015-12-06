import lc3b_types::*;

module cccomp
(
	input lc3b_nzp cc,
	input lc3b_nzp nzp,
	input lc3b_nzp mem_nzp,
	input logic [1:0] mem_res_bits,
	input [3:0] opcode,
	output logic branch_enable
);

always_comb
begin
	if (opcode == op_br && (((mem_nzp[0] && nzp[0] || mem_nzp[1] && nzp[1] || mem_nzp[2] && nzp[2]) && mem_res_bits == 2'b11) || cc[0] && nzp[0] || cc[1] && nzp[1] || cc[2] && nzp[2]|| nzp == 3'b111))
		branch_enable = 1;
	
	else
		branch_enable = 0;
end

endmodule : cccomp

