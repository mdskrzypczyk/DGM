module mem_stage(
	input lc3b_ipacket in_ipacket,
	input lc3b_word alu_res,
	input lc3b_word addrgen_res,
	input lc3b_word mem_rdata,

	output lc3b_word mem_address,
	output lc3b_word mem_wdata,
	output lc3b_word mem_data_out,
	output lc3b_word br_addr_out
);

lc3b_word wdatamux_out, addrmux_out;

/* Mux for Memory address */
mux2 #(.width(16)) addrmux(
	.sel(in_ipacket.wdatamux_sel),
	.a(alu_res),
	.b(addrgen_res),
	.f(addrmux_out)
);

/* Mux for Memory write data */
mux2 #(.width(16)) wdatamux(
	.sel(in_ipacket.addrmux_sel),
	.a(alu_res),
	.b(addrgen_res),
	.f(wdatamux_out)
);

/* Shiftup unit for STB */
shiftup wdata_shiftup(
	.shift(addrmux_out[0]),
	.byte_op(in_ipacket.byte_op),
	.in(wdatamux_out),
	.out(mem_wdata)
);

/* Shiftdown unit for LDB */
shiftdown rdata_shiftdown(
	.shift(addrmux_out[0]),
	.byte_op(in_ipacket.byte_op),
	.in(mem_rdata),
	.out(mem_data_out)
);

assign br_addr_out = addrmux_out;
assign mem_address = addrmux_out;


endmodule : mem_stage