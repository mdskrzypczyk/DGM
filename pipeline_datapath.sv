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
logic if_id_bubble, id_ie_bubble, ie_mem_bubble, mem_wb_bubble;

lc3b_ipacket if_ipacket, if_id_ipacket, id_ie_ipacket, ie_mem_ipacket, mem_wb_ipacket;

/* IF signals */
lc3b_word pc_addr_out, wbdata;

/* ID signals */
logic sr2mux_sel;
lc3b_reg sr1, sr2, dr;
lc3b_word id_instruction;
lc3b_word id_sr1_out, id_sr2_out,id_sext_out;

/* IE signals */
logic[1:0] ex_pcmux_sel;
lc3b_word ie_sr1_in, ie_sr2_in,ie_sext_in;
lc3b_word ie_alu_out, ie_addrgen_out;
lc3b_word ie_sr_store;

/* MEM signals */
lc3b_word mem_alu_in, mem_addrgen_in;
lc3b_word mem_br_addr_out, mem_data_out,temp_out;
logic load_addr, mem_hold, mem_stage_resp;
lc3b_word mem_sr_store;
logic sti_ldi_sig;

/* WB signals */
lc3b_word wbalu_data, wbmem_data, wbmem_addr, wbpc;
logic wb_regfile_mux_sel;
logic wb_drmux_sel;
logic wb_load_regfile;
logic br_taken;
lc3b_reg wbdr;

/* Hazard Signals*/
lc3b_word mem_data_forward, wb_data_forward;
logic [1:0] opAmux_sel, opBmux_sel, opSrmux_sel;

/* Branch prediction signals */
lc3b_word if_pc;
logic tag_hit, taken_prediction;
lc3b_word pc_tar;
lc3b_pc_ways ways;
logic btb_stall; //the btb_stall logic 

/* iFetch Stage */
if_stage if_module(
	.clk(clk),
	/* New PC values */
	.br_add(pc_addr_out),
	.wb_data(wbdata),
	//.mem_data(mem_data_forward),
	
	/* Generated iPacket */
	.packet(if_ipacket),
	.if_pc(if_pc),
	
	.pcmux_sel(ex_pcmux_sel),
	.pc_stall((pc_stall || btb_stall)),
	
	/* branch prediction signals */
	.tag_hit(tag_hit), // the tag hit signal from btb
	.ways(ways), //ways offset when btb hit 
	.pc_tar(pc_tar), //target pc address 
	.taken_prediction(taken_prediction), //branch prediction bit 
	.br_packet(if_id_ipacket),
	.flush(flush),
	.flush_pc(id_ie_ipacket.pc),
	.br_taken(br_taken),
	
	
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
	.stall((if_id_stall || btb_stall)),
	.flush(flush),
	.ipacket_in(if_ipacket),
	.bubble(if_id_bubble), //CHANGE
	
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
	.stall((id_ie_stall || btb_stall)),
	.flush(flush),
	.ipacket_in(if_id_ipacket),
	.sr1_in(id_sr1_out),
	.sr2_in(id_sr2_out),
	.sext_in(id_sext_out),
	.bubble(id_ie_bubble), //CHANGE
	
	.ipacket_out(id_ie_ipacket),
	.sr1_out(ie_sr1_in),
	.sr2_out(ie_sr2_in),
	.sext_out(ie_sext_in)
);

//EXECUTE MODULE
exe_stage IE(
	.clk(clk),
	.stall(id_ie_stall),
	.ex_ipacket(id_ie_ipacket),
	.SEXT(ie_sext_in),
	.sr1(ie_sr1_in),
	.sr2(ie_sr2_in),
	.opAmux_sel(opAmux_sel), 
	.opBmux_sel(opBmux_sel), 
	.opSrmux_sel(opSrmux_sel), 
	.mem_data_forward(mem_data_forward),
	.wb_data_forward(wb_data_forward),
	
	.alu_out(ie_alu_out),
	.bradd_out(ie_addrgen_out),
	.sr_store(ie_sr_store),
	
	/* Branch Res Stuff */
	.mem_ipacket(ie_mem_ipacket),
	.br_taken(br_taken),
	.pcmux_sel(ex_pcmux_sel),
	.pc_addr_out(pc_addr_out),
	.pip_flush(flush)
);

//IE/MEM MEAT
ie_mem_meat IE_MEM(
	.clk(clk),
	.load_addr(1'b0),		//FIXo
	.stall((ie_mem_stall || btb_stall)),
	.in_ipacket(id_ie_ipacket),
	.ie_alu_res(ie_alu_out),
	.ie_addrgen_res(ie_addrgen_out),
	.meat_mem_rdata(mem_mem_rdata),
	.sr_store_in(ie_sr_store),
	.dmem_resp(mem_stage_resp),
	.bubble(ie_mem_bubble), //CHANGE
	
	.sti_ldi_sig(sti_ldi_sig),
	.sr_store_out(mem_sr_store),
	.meat_alu_out(mem_alu_in),
	.meat_addrgen_out(mem_addrgen_in),
	.out_ipacket(ie_mem_ipacket)
);

//MEM MODULE
mem_stage MEM(
	.in_ipacket(ie_mem_ipacket),
	.alu_res(mem_alu_in),
	.addrgen_res(mem_addrgen_in),
	.mem_rdata(mem_mem_rdata),
	.mem_resp(mem_mem_resp),
	.sr_store(mem_sr_store),
	.hold(sti_ldi_sig),
	
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
	.stall((mem_wb_stall || btb_stall)),
	.ipacket(ie_mem_ipacket),
	.alu_in(mem_alu_in),
	.mem_data(mem_data_out),
	.br_address(mem_addrgen_in),
	.bubble(mem_wb_bubble), //CHANGE
	
	.alu_out(wbalu_data),
	.mem_data_out(wbmem_data),
	.br_address_out(wbmem_addr),
	.ipacket_out(mem_wb_ipacket)
);

//WB MODULE
WB write_back(
	.clk(clk),
	.mem_in(wbmem_data),
	.alu_in(wbalu_data),
	.br_addr(wbmem_addr),
	.ipacket(mem_wb_ipacket),


	.wbdata(wbdata),
	.wbpc(wbpc),
	.wbdr(wbdr),
	.wbdrmux_sel(wb_drmux_sel),
	.regfile_mux_sel(wb_regfile_mux_sel),
	.load_regfile(wb_load_regfile)
);


/* Hazard Detection units*/

hazard_detection hazard_detection_module
(
	/* INPUT */
	/* If signals */
	.if_mem_resp(if_mem_resp),
	.if_memread(if_memread),
	
	/* Mem signals */
	.mem_mem_resp(mem_mem_resp),
	.mem_memread(mem_memread),
	.mem_memwrite(mem_memwrite),	
	
	/* WB signal */
	.br_taken(br_taken),
	
	/*Sti Ldi*/
	.sti_ldi_sig(sti_ldi_sig),
	

	/*Packets for hazard detection*/
	.exe_packet(id_ie_ipacket),
	.mem_packet(ie_mem_ipacket),
	.wb_packet(mem_wb_ipacket),
	
	/* OUTPUT */
	/* Stall Signals */
	.pc_stall(pc_stall),
	.if_id_stall(if_id_stall),
	.id_ie_stall(id_ie_stall),
	.ie_mem_stall(ie_mem_stall),
	.mem_wb_stall(mem_wb_stall),
	
	.if_id_bubble(if_id_bubble),
	.id_ie_bubble(id_ie_bubble),
	.ie_mem_bubble(ie_mem_bubble),
	.mem_wb_bubble(mem_wb_bubble),
	
	/* Forwarding signals*/
	.opAmux_sel(opAmux_sel),
	.opBmux_sel(opBmux_sel),
	.opSrmux_sel(opSrmux_sel)
	
);

forwarding_selector fowarding_selector
(
	.mem_rdata(mem_data_out),
	.mem_alu_data(mem_alu_in),
	.mem_addrgen(mem_addrgen_in),
	.mem_packet(ie_mem_ipacket),
	.wb_data(wbdata),
	.wb_packet(mem_wb_ipacket),
	
	.mem_out(mem_data_forward),
	.wb_out(wb_data_forward)
);

/* the branch target buffer */
// current BTB does not perform new predictions when loading 
BTB btb_module(
	.clk(clk),
	.pc_in(if_pc),	//pc value from IF stage, use for check BTB 
	.ipacket_in(id_ie_ipacket),	//ipacket from WB stage, used for store back 
	.if_packet_in(if_ipacket),
	.pc_target(pc_addr_out),	//target jumping pc from WB stage 
	.branch_resolve(br_taken),	//branch resolve bit, check if miss predict 
	
	.stall(btb_stall), //the btb_stall logic 
	
	.tag_hit(tag_hit),
	.ways(ways), //ways offset when hit 
	.pc_tar(pc_tar),
	.taken_prediction(taken_prediction)
);



endmodule : pipeline_datapath
