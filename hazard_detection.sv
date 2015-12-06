import lc3b_types::*;

module hazard_detection
(
	/* If signals */
	input if_mem_resp,
	input if_memread,
	
	/* Ex Signals */
	input alg_done,
	
	/* Mem signals */
	input mem_memread,
	input mem_memwrite,
	input mem_mem_resp,
	
	/* WB signal */
	input logic br_taken,
	
	/*Sti Ldi*/
	input sti_ldi_sig,
	
	/*Packets for hazard detection*/
	input lc3b_ipacket exe_packet,
	input lc3b_ipacket mem_packet,
	input lc3b_ipacket wb_packet,
	
	/* Stall Signals */
	output logic pc_stall,
	output logic if_id_stall,
	output logic id_ie_stall,
	output logic ie_mem_stall,
	output logic mem_wb_stall,
	
	/* bubble signals */
	output logic if_id_bubble,
	output logic id_ie_bubble,
	output logic ie_mem_bubble,
	output logic mem_wb_bubble,
	
	/* Forwarding signals*/
	output logic [1:0] opAmux_sel,
	output logic [1:0] opBmux_sel,
	output logic [1:0] opSrmux_sel
	
);

always_comb
begin
	/* Default Stall signals */
	pc_stall = 1'b0;
	if_id_stall = 1'b0;
	id_ie_stall = 1'b0;
	ie_mem_stall = 1'b0;
	mem_wb_stall = 1'b0;
	if_id_bubble = 1'b0;
	id_ie_bubble = 1'b0;
	ie_mem_bubble = 1'b0;
	mem_wb_bubble = 1'b0;
	
	/*TODO If statements like this may be to slow*/
	
	/* Instruction Cache Miss */
	if(if_mem_resp == 1'b0 && if_memread && br_taken == 1'b0)
	begin
		pc_stall = 1'b1;
		if_id_stall = 1'b1;
		id_ie_stall = 1'b1;
		ie_mem_stall = 1'b1;
		mem_wb_stall = 1'b1;
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
	
	if(alg_done == 1'b0)
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
	opAmux_sel = 2'b0;
	opBmux_sel = 2'b0;
	opSrmux_sel = 2'b0;
	

	/* opA logic */
	//tests if the operation in exe stage might need operands to be forwarded to opA
	if (exe_packet.opA == 1'b1 )
	begin 
				
		//tests if there is a dependency in the mem stage. That data is the most recent that can be forwarded
		if( (exe_packet.sr1 == mem_packet.dr_sr) && (mem_packet.forward == 1'b1)  )
		begin
			opAmux_sel = 2'b01;
		end
		//tests to see if the dependency is in the wb stage.
		else if ((exe_packet.sr1 == wb_packet.dr_sr) && (wb_packet.forward == 1'b1)  )
		begin
			opAmux_sel = 2'b10;
		end
		
		//do not forward
		else
		begin
			opAmux_sel = 2'b00;
		end
	end
	
	/* opB logic */
	//tests if the operation in exe stage might need operands to be forwarded
	if (exe_packet.opB == 1'b1 )
	begin 
				
		//tests if there is a dependency in the mem stage. That data is the most recent that can be forwarded
		if( (exe_packet.sr2 == mem_packet.dr_sr) && (mem_packet.forward == 1'b1)  )
		begin 
			opBmux_sel = 2'b01;
		end
		//tests to see if the dependency is in the wb stage.
		else if ( (exe_packet.sr2 == wb_packet.dr_sr) && (wb_packet.forward == 1'b1)  )
		begin
			opBmux_sel = 2'b10;
		end
		
		//do not forward
		else
		begin
			opBmux_sel = 2'b00;
		end
	end
		
	
	/* Sr store logic*/
	//tests if the operation is a store
	if (exe_packet.mem_write == 1'b1 )
	begin 
				
		//tests if there is a dependency in the mem stage. That data is the most recent that can be forwarded
		if( (exe_packet.dr_sr == mem_packet.dr_sr) && (mem_packet.forward == 1'b1)  )
		begin
			opSrmux_sel = 2'b01;
		end
		//tests to see if the dependency is in the wb stage.
		else if ( (exe_packet.dr_sr == wb_packet.dr_sr) && (wb_packet.forward == 1'b1)  )
		begin
			opSrmux_sel = 2'b10;
		end
		
		//do not forward
		else
		begin
			opSrmux_sel = 2'b00;
		end
	end
	
end


endmodule : hazard_detection