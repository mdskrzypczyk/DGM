module pipeline_datapath(
	input clk,
	input mem_resp,
	input lc3b_word mem_rdata,
	
	output mem_read,
	output mem_write,
	output lc3b_word mem_address,
	output lc3b_burst mem_wdata
);

/* Internal signals */
logic if_id_stall, id_ie_stall, ie_mem_stall, mem_wb_stall;
lc3b_ipacket if_ipacket, if_id_ipacket, id_ie_ipacket, ie_mem_ipacket, mem_wb_ipacket;

/* IF signals */
lc3b_word br_addr_out, wbdata;

/* ID signals */
logic sr2mux_sel;
lc3b_reg sr1, sr2, dr;
lc3b_word id_instruction;
lc3b_word id_sr1_out, id_sr2_out,id_sext_out;

/* IE signals */
lc3b_word ie_sr1_in, ie_sr2_in,ie_sext_in;
lc3b_word ie_alu_out, ie_addrgen_out;

/* MEM signals */
lc3b_word mem_alu_in, mem_addrgen_in;
lc3b_word mem_br_addr_out, mem_data_out;
logic load_addr, mem_hold;

/* WB signals */
lc3b_word wbalu_data, wbmem_data, wbmem_addr, wbpc;

/* iFetch Stage */
if_stage if_module(
	.clk(clk),
	/* New PC values */
	.br_add(br_addr_out),
	.wb_data(wbdata),
	
	/* Generated iPacket */
	.ipacket(if_ipacket)
);

/* IF/ID Meat */
if_id_meat IF_ID(
	.clk(clk),
	.stall(if_id_stall),
	.ipacket_in(if_id_ipacket),
	
	.ipacket_out(id_ie_ipacket),
	.instruction(id_instruction),
	.sr1(sr1),
	.sr2(sr2),
	.dr(dr),
	.sr2mux_sel(sr2mux_sel)
);

/* Decode Stage */
ID decode_module(
	.ipacket(if_id_ipacket),
	.sr1(sr1),
	.sr2(sr2),
	.dr(dr),
	.wbpc(wbpc),
	.wbdata(wbdata),
	.sr2_mux_sel(sr2mux_sel),
	.instruction(id_instruction),
	
	.sr1_out(id_sr1_out),
	.sr2_out(id_sr2_out),
	.sext_out(id_sext_out)
);

/* ID/IE Meat */
id_exe_meat ID_EXE(
	.clk(clk),
	.stall(id_ie_stall),
	.ipacket_in(id_ie_ipacket),
	.sr1_in(id_sr1_out),
	.sr2_in(id_sr2_out),
	.sext_in(id_sext_out),
	
	.ipacket_out(ie_mem_ipacket),
	.sr1_out(ie_sr1_in),
	.sr2_out(ie_sr2_in),
	.sext_out(ie_sext_in)
);

//EXECUTE MODULE
exe_stage IE(
	.ipacket(id_ie_ipacket),
	.SEXT(ie_sext_in),
	.sr1(ie_sr1_in),
	.sr2(ie_sr2_in),
	
	.alu_out(ie_alu_out),
	.bradd_out(ie_addrgen_out)
);

//IE/MEM MEAT
ie_mem_meat IE_MEM(
	.clk(clk),
	.load_addr(load_addr),
	.stall(ie_mem_stall),
	.in_ipacket(ie_mem_ipacket),
	.alu_res(ie_alu_out),
	.addrgen_res(ie_addrgen_out),
	.meat_mem_rdata(mem_rdata),

	.meat_alu_out(mem_alu_in),
	.meat_addrgen_out(mem_addrgen_in),
	.hold(mem_hold)
);

//MEM MODULE
mem_stage MEM(
	.in_ipacket(mem_wb_ipacket),
	.alu_res(mem_alu_in),
	.addrgen_out(mem_addrgen_in),
	.mem_rdata(mem_rdata),

	.mem_address(mem_address),
	.mem_wdata(mem_wdata),
	.mem_data_out(mem_data_out)
);

//MEM/WB MEAT
mem_wb_meat MEM_WB(
	.clk(clk),
	.stall(mem_wb_stall),
	.ipacket(ie_mem_ipacket),
	.alu_in(mem_alu_in),
	.mem_data(mem_data_out),
	.mem_address(mem_addrgen_in),
	
	.alu_out(wbalu_data),
	.mem_data_out(wbmem_data),
	.mem_address_out(wbmem_addr)
);

//WB MODULE
WB write_back(
	.mem_in(wbmem_data),
	.alu_in(wbalu_data),
	.br_addr(wbmem_addr),
	.ipacket(mem_wb_ipacket),
	
	.br_addr_out(br_addr_out),
	.br_taken(),
	.wbdata(wbdata),
	.wbpc(wbpc)
);

endmodule : pipeline_datapath