import lc3b_types::*;

module br_dec(
	input br_sig,
	input [3:0] ex_opcode,
	input [3:0] mem_opcode,
	output logic branch_enable
);

always_comb
begin
	branch_enable = 0;
	if(br_sig || mem_opcode == op_trap)
		branch_enable = 1;
	case(ex_opcode)
		op_jmp: branch_enable = 1;
		op_jsr: branch_enable = 1;
		default : ;
	endcase

end

endmodule : br_dec