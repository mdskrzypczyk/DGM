import lc3b_types::*;

module pipeline_datapath(
	input clk,	
	
	/* memory siganls */
	/* IF memory siganls */
	output lc3b_word if_memaddr,
	output logic[1:0] if_mem_byte_enable,
	input if_mem_resp,
	input lc3b_word if_mem_rdata,
	output if_memread,
	
	/* MEM memory signals*/
	output lc3b_word mem_memaddr,
	output logic[1:0] mem_mem_byte_enable,
	input mem_mem_resp,
	input lc3b_word mem_mem_rdata,
	output logic mem_memread,
	output lc3b_word mem_mem_wdata,
	output logic mem_memwrite
);



/* Internal signals */
logic pc_stall, if_id_stall, id_ie_stall, ie_mem_stall, mem_wb_stall, flush;
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
lc3b_word ie_sr_store;

/* MEM signals */
lc3b_word mem_alu_in, mem_addrgen_in;
lc3b_word mem_br_addr_out, mem_data_out,temp_out;
logic load_addr, mem_hold, mem_stage_resp;
lc3b_word mem_sr_store;

/* WB signals */
lc3b_word wbalu_data, wbmem_data, wbmem_addr, wbpc;
logic[1:0] wb_pcmux_sel;
logic wb_regfile_mux_sel;
logic wb_drmux_sel;
logic wb_load_regfile;
lc3b_reg wbdr;


/* iFetch Stage */
if_stage if_module(
	.clk(clk),
	/* New PC values */
	.br_add(br_addr_out),
	.wb_data(wbdata),
	
	/* Generated iPacket */
	.packet(if_ipacket),
	
	.pcmux_sel(wb_pcmux_sel),
	.pc_stall(pc_stall),
	
	/* memory signals */
	.if_memaddr(if_memaddr),
	.if_mem_byte_enable(if_mem_byte_enable),
	.if_mem_resp(if_mem_resp),
	.if_memread(if_memread),
	.if_mem_rdata(if_mem_rdata)
	
);

/* IF/ID Meat */
if_id_meat IF_ID(
	.clk(clk),
	.stall(if_id_stall),
	.flush(flush),
	.ipacket_in(if_ipacket),
	
	.ipacket_out(if_id_ipacket),
	.sr1(sr1),
	.sr2(sr2),
	.dr(dr),
	.sr2mux_sel(sr2mux_sel)
);

/* Decode Stage */
ID decode_module(
	.clk(clk),
	.ipacket(if_id_ipacket),
	.sr1(sr1),
	.sr2(sr2),
	.dr_meat(dr),
	.wbdr(wbdr),
	.drmux_sel(wb_drmux_sel),
	.wbpc(wbpc),
	.wbdata(wbdata),
	.sr2_mux_sel(sr2mux_sel),
	.regfile_mux_sel(wb_regfile_mux_sel),
	.load_regfile(wb_load_regfile),
	
	.sr1_out(id_sr1_out),
	.sr2_out(id_sr2_out),
	.sext_out(id_sext_out)
);

/* ID/IE Meat */
id_exe_meat ID_EXE(
	.clk(clk),
	.stall(id_ie_stall),
	.flush(flush),
	.ipacket_in(if_id_ipacket),
	.sr1_in(id_sr1_out),
	.sr2_in(id_sr2_out),
	.sext_in(id_sext_out),
	
	.ipacket_out(id_ie_ipacket),
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
	.bradd_out(ie_addrgen_out),
	.sr_store(ie_sr_store)
);

//IE/MEM MEAT
ie_mem_meat IE_MEM(
	.clk(clk),
	.load_addr(1'b0),		//FIXo
	.stall(ie_mem_stall),
	.flush(flush),
	.in_ipacket(id_ie_ipacket),
	.ie_alu_res(ie_alu_out),
	.ie_addrgen_res(ie_addrgen_out),
	.meat_mem_rdata(mem_mem_rdata),
	.sr_store_in(ie_sr_store),
	.dmem_resp(mem_stage_resp),
	
	.sr_store_out(mem_sr_store),
	.meat_alu_out(mem_alu_in),
	.meat_addrgen_out(mem_addrgen_in),
	.out_ipacket(ie_mem_ipacket),
	.hold(mem_hold)
);

//MEM MODULE
mem_stage MEM(
	.in_ipacket(ie_mem_ipacket),
	.alu_res(mem_alu_in),
	.addrgen_res(mem_addrgen_in),
	.mem_rdata(mem_mem_rdata),
	.mem_resp(mem_mem_resp),
	.sr_store(mem_sr_store),
	
	.dmem_resp(mem_stage_resp),
	.mem_address(mem_memaddr),
	.mem_wdata(mem_mem_wdata),
	.mem_data_out(mem_data_out),
	.mem_read(mem_memread),
	.mem_write(mem_memwrite),
	.mem_byte_enable(mem_mem_byte_enable)			//Connect to pipeline mem_byte_enable
);

//MEM/WB MEAT
mem_wb_meat MEM_WB(
	.clk(clk),
	.stall(mem_wb_stall),
	.flush(flush),
	.ipacket(ie_mem_ipacket),
	.alu_in(mem_alu_in),
	.mem_data(mem_data_out),
	.br_address(mem_addrgen_in),
	
	.alu_out(wbalu_data),
	.mem_data_out(wbmem_data),
	.br_address_out(wbmem_addr),
	.ipacket_out(mem_wb_ipacket)
);

//WB MODULE
WB write_back(
	.clk(clk),
	.pip_flush(flush),
	.mem_in(wbmem_data),
	.alu_in(wbalu_data),
	.br_addr(wbmem_addr),
	.ipacket(mem_wb_ipacket),
	
	.br_addr_out(br_addr_out),
	.wbdata(wbdata),
	.pcmux_sel(wb_pcmux_sel),
	.wbpc(wbpc),
	.wbdr(wbdr),
	.wbdrmux_sel(wb_drmux_sel),
	.regfile_mux_sel(wb_regfile_mux_sel),
	.load_regfile(wb_load_regfile)
);

hazard_detection hazard_detection_module
(
	/* If signals */
	.if_mem_resp(if_mem_resp),
	.if_memread(if_memread),
	
	/* Mem signals */
	.mem_mem_resp(mem_mem_resp),
	.mem_memread(mem_memread),
	.mem_memwrite(mem_memwrite),	
	
	/*Sti Ldi*/
	.sti_ldi_sig(1'b0),
	
	.pc_stall(pc_stall),
	.if_id_stall(if_id_stall),
	.id_ie_stall(id_ie_stall),
	.ie_mem_stall(ie_mem_stall),
	.mem_wb_stall(mem_wb_stall)
);

endmodule : pipeline_datapath