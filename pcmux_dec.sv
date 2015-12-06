import lc3b_types::*;

module pcmux_dec(
	input [3:0] mem_opcode,
	input lc3b_ipacket packet_in,
	input branch_enable,
	input [1:0] ex_pcmux_sel, mem_pcmux_sel,
	output logic [1:0] pcmux_sel
);

always_comb
begin
	if(mem_opcode == op_trap)
		pcmux_sel = mem_pcmux_sel;
	else if(branch_enable == packet_in.br_prediction)
		pcmux_sel = 2'b0;
	else
		pcmux_sel = ex_pcmux_sel;
	
end

endmodule : pcmux_dec