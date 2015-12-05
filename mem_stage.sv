import lc3b_types::*;

module mem_stage(
	input lc3b_ipacket in_ipacket,
	input lc3b_word alu_res,
	input lc3b_word addrgen_res,
	input lc3b_word mem_rdata,
	input mem_resp,
	input lc3b_word sr_store,
	input hold,

	output logic dmem_resp,
	output lc3b_word mem_address,
	output lc3b_word mem_wdata,
	output lc3b_word mem_data_out,	//memory data output
	output logic mem_read,
	output logic mem_write,
	output logic[1:0] mem_byte_enable
);

lc3b_word  addrmux_out;
lc3b_word datamux_out;

assign mem_address = addrmux_out;
assign dmem_resp = mem_resp;

always_comb
begin
	if(hold && in_ipacket.opcode == op_sti)
	begin	
		mem_write = 1'b0;
		mem_read = 1'b1;
	end
	else
	begin	
		mem_read = in_ipacket.mem_read;
		mem_write = in_ipacket.mem_write;
	end
	if(in_ipacket.byte_op)
	begin
		case(addrmux_out[0])
			1'b0:
				mem_byte_enable = 2'b01;
			1'b1:
				mem_byte_enable = 2'b10;
			endcase
	end
	else
		mem_byte_enable = 2'b11;
end

/* Mux for Memory address */
mux2 #(.width(16)) addrmux(
	.sel(in_ipacket.wdatamux_sel),
	.a(alu_res),
	.b(addrgen_res),
	.f(addrmux_out)
);



/* Shiftup unit for STB */
shiftup wdata_shiftup(
	.shift(addrmux_out[0]),
	.byte_op(in_ipacket.byte_op),
	.in(datamux_out),
	.out(mem_wdata)
);

/* Shiftdown unit for LDB */
shiftdown rdata_shiftdown(
	.shift(addrmux_out[0]),
	.byte_op(in_ipacket.byte_op),
	.in(mem_rdata),
	.out(mem_data_out)
);

/* Mux for selecting the sr2(dr ) for stores*/
mux2 #(.width(16)) datamux
(
	.sel(in_ipacket.datamux_sel),
	.a(alu_res),
	.b(sr_store),
	
	.f(datamux_out)
);

endmodule : mem_stage