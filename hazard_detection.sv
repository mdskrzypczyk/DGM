module hazard_detection
(
	input if_mem_resp,
	input mem_mem_resp,
	input sti_ldi_sig,
	
	output logic pc_stall,
	output logic if_id_stall,
	output logic id_ie_stall,
	output logic ie_mem_stall,
	output logic mem_wb_stall
);

always_comb
begin
	/* Default Stall signals */
	pc_stall = 1'b0;
	if_id_stall = 1'b0;
	id_ie_stall = 1'b0;
	ie_mem_stall = 1'b0;
	mem_wb_stall = 1'b0;
	
	/*TODO If statement like this may be to slow*/
	
	
	/* Instruction Cache Miss */
	if(if_mem_resp == 1'b0)
	begin
		pc_stall = 1'b1;
	end
	
	/* Data Cache Miss */
	if(mem_mem_resp == 1'b0)
	begin
		pc_stall = 1'b1;
		if_id_stall = 1'b1;
		id_ie_stall = 1'b1;
		ie_mem_stall = 1'b1;
		mem_wb_stall = 1'b1;
	end
	
	/* LDI or STI */
	if(sti_ldi_sig == 1'b0)
	begin
		pc_stall = 1'b1;
		if_id_stall = 1'b1;
		id_ie_stall = 1'b1;
		ie_mem_stall = 1'b1;
		mem_wb_stall = 1'b1;
	end
	
end


endmodule : hazard_detection