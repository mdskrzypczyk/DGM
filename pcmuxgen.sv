module pcmuxgen(
	input [1:0] pcmux_sel,
	input branch_enable,
	input [3:0] opcode,
	output logic [1:0] wb_pc_mux_sel
);

always_comb
begin
	if(branch_enable && opcode == 4'b0000)
		wb_pc_mux_sel = 2'b10;
	else
		wb_pc_mux_sel = pcmux_sel;
end

endmodule : pcmuxgen