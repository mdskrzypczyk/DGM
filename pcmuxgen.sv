import lc3b_types::*;

module pcmuxgen(
	input branch_enable,
	input lc3b_ipacket ex_ipacket,
	input lc3b_ipacket mem_ipacket,
	output logic [1:0] wb_pc_mux_sel,
	output logic [1:0] pc_addr_sel
);

always_comb
begin
	wb_pc_mux_sel = 2'b00;
	pc_addr_sel = 2'b00;
	case(ex_ipacket.opcode)
		op_br: begin
			if(branch_enable)
			begin
				wb_pc_mux_sel = ex_ipacket.pcmux_sel;
				pc_addr_sel = ex_ipacket.pc_addr_sel;
			end
		end
		op_jmp: begin
			wb_pc_mux_sel = ex_ipacket.pcmux_sel;
			pc_addr_sel = ex_ipacket.pc_addr_sel;
		end
		op_jsr: begin
			wb_pc_mux_sel = ex_ipacket.pcmux_sel;
			pc_addr_sel = ex_ipacket.pc_addr_sel;
		end
		default : wb_pc_mux_sel = 2'b00;
	endcase
	if(mem_ipacket.opcode == op_trap)
	begin
		wb_pc_mux_sel = mem_ipacket.pcmux_sel;
		pc_addr_sel = mem_ipacket.pc_addr_sel;
	end
end

endmodule : pcmuxgen
