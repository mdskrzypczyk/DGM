import lc3b_types::*;

module if_stage
(
	input clk,
	input br_add,
	input wb_data,
	input pcmux_sel,
	
	output ipacket
);

/*internal signals*/
lc3b_word pcmux_out, pc_out, ic_out, plus2_out;
logic ic_mem_resp, load_pc;

/* PC PLUS 2 UNIT */
plus2 plus2(
	.in(pc),
	
	.out(plus2_out)
);

/* LOAD PC MUX */
mux4 pcmux
(
	.sel(pcmux_sel),
	.a(plus2_out),
	.b(wb_data),
	.c(br_add),
	.d(16'h0),				//USEABLE SPACE
	
	.f(pcmux_out)
);

/* Instruction Memory Implementation */
instruction_cache instruction_cache
(
	.clk(clk),
	.mem_address(pc_out),
	.mem_read(1),
	.mem_byte_enable(2'b11),
	
	.mem_rdata(ic_out),
	.mem_resp(ic_mem_resp)	
);

/* PC Register */
register pc
(
	.clk(clk),
	.load(load_pc),
	.in(pcmux_out),
	
	.out(pc_out)
); 

/* Ipacket Generator */
ipacket_creator ipacket_creator 
(
	.inst(ic_out),
	.ipacket(ipacket)
);

/* Load Logic for PC */
pc_load_logic pc_load_logic
(
	.load_pc(load_pc)
);




endmodule : if_stage