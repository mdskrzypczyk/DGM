module hazard_detection
(
	/* If signals */
	input if_mem_resp,
	input if_memread,
	
	/* Mem signals */
	input mem_memread,
	input mem_memwrite,
	input mem_mem_resp,
	
	/* WB signal */
	input logic br_taken,
	
	/*Sti Ldi*/
	input sti_ldi_sig,
	
	/*Packets for hazard detection*/
	input exe_packet,
	input mem_packet,
	input wb_packet,
	
	/* Stall Signals */
	output logic pc_stall,
	output logic if_id_stall,
	output logic id_ie_stall,
	output logic ie_mem_stall,
	output logic mem_wb_stall,
	
	output logic [1:0] curr_case
);

always_comb
begin
	/* Default Stall signals */
	pc_stall = 1'b0;
	if_id_stall = 1'b0;
	id_ie_stall = 1'b0;
	ie_mem_stall = 1'b0;
	mem_wb_stall = 1'b0;
	
	/*TODO If statements like this may be to slow*/
	
	/* Instruction Cache Miss */
	if(if_mem_resp == 1'b0 && if_memread)
	begin
		pc_stall = 1'b1;
		if_id_stall = 1'b1;
		id_ie_stall = 1'b1;
		ie_mem_stall = 1'b1;
		mem_wb_stall = 1'b1;
		//bubble = 1'b1;
	end
	
	/* Data Cache Miss */
	if(mem_mem_resp == 1'b0 && (mem_memwrite || mem_memread))
	begin
		pc_stall = 1'b1;
		if_id_stall = 1'b1;
		id_ie_stall = 1'b1;
		ie_mem_stall = 1'b1;
		mem_wb_stall = 1'b1;
	end
	
	/* LDI or STI */
	if(sti_ldi_sig == 1'b1)
	begin
		pc_stall = 1'b1;
		if_id_stall = 1'b1;
		id_ie_stall = 1'b1;
		mem_wb_stall = 1'b1;
	end
	
end

/* Case selecting logic*/
always_comb
begin

	
	curr_case = 2'b0;
end


endmodule : hazard_detection