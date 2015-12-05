import lc3b_types::*;

module pcmuxgen(
	input [1:0] pcmux_sel,
	input branch_enable,
	input [3:0] opcode,
	output logic [1:0] wb_pc_mux_sel
);

always_comb
begin
	wb_pc_mux_sel = 2'b00;
	case(opcode)
		op_br: begin
			if(branch_enable)
				wb_pc_mux_sel = pcmux_sel;
		end
		op_jmp: wb_pc_mux_sel = pcmux_sel;
		op_jsr: wb_pc_mux_sel = pcmux_sel;
		default: wb_pc_mux_sel = 2'b00;
	endcase
end

endmodule : pcmuxgen