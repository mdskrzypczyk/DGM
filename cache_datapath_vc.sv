import lc3b_types::*;

module cache_datapath_vc
(
	input clk,
	
	//from L1 cache(needed for swap logic)
	input lc3b_word arbiter_address,
	
	//from L2 cache 
	input lc3b_word l2_address,
	input lc3b_burst l2_wdata,
	
	//from controller
	input logic rdatamux_sel,
	input logic waymux_sel,
	input logic load_buffer,
	input logic load_entry,
	input logic pmem_addressmux_sel,
	
	//from physical memory
	input lc3b_burst pmem_rdata_in,
	
	//to controller
	output logic swap,
	output logic dirty,
	
	//to l2 cache
	output lc3b_burst rdata_out,
	
	//to physical memory
	output lc3b_word pmem_address, 
	output lc3b_burst pmem_wdata
);

/* Internal Signals */
lc3b_tag_vc arbiter_tag, l2_tag;
lc3b_cache_offset arbiter_offset,l2_offset;
lc3b_tag_vc tag_out_A, tag_out_B, tag_out_C, tag_out_D, tagmux_out;
lc3b_burst data_out_A, data_out_B, data_out_C, data_out_D, datamux_out;
logic dirty_out_A,dirty_out_B,dirty_out_C,dirty_out_D, dirtymux_out;
lc3b_burst buffer_out;
logic [1:0] lru_way, swap_way, waymux_out;

/* Data Array */
data_array_vc data_array
(
	.clk(clk),
	.load(load_entry),
	.way(waymux_out),
	.data_in(l2_wdata),
	
	.data_out_A(data_out_A),
	.data_out_B(data_out_B),
	.data_out_C(data_out_C),
	.data_out_D(data_out_D)
);


/* Tag Array */
tag_array_vc tag_array
(
	.clk(clk),
	.load(load_entry),
	.way(waymux_out),
	.tag_in(l2_address[15:4]),
	
	.tag_out_A(tag_out_A),
	.tag_out_B(tag_out_B),
	.tag_out_C(tag_out_C),
	.tag_out_D(tag_out_D)
);

/* Dirty array */
dirty_array_vc dirty_array
(
	.clk(clk),
	.load(load_entry),
	.way(waymux_out),
	.dirty_in(1'b1),
	
	.dirty_out_A(dirty_out_A),
	.dirty_out_B(dirty_out_B),
	.dirty_out_C(dirty_out_C),
	.dirty_out_D(dirty_out_D)
);


/* Lru Unit */
lru_unit_vc lru_unit
(
	.clk(clk),
	.load(load_entry),
	.used_way(waymux_out),
	
	.lru_way(lru_way)

);

/* Address Parser */
address_parser_vc address_parser
(
	.arbiter_address(arbiter_address),
	.l2_address(l2_address),
	
	.arbiter_tag(arbiter_tag),
	.arbiter_offset(arbiter_offset),
	.l2_tag(l2_tag),
	.l2_offset(l2_offset)
);

/* Comparison Module */
comparison_module_vc comparison_module
(
	.arbiter_tag(arbiter_tag),
	.l2_tag(l2_tag),
	.tag_out_A(tag_out_A),
	.tag_out_B(tag_out_B),
	.tag_out_C(tag_out_C),
	.tag_out_D(tag_out_D),
	
	.swap(swap),
	//.hit(hit),
	.swap_way(swap_way)
	//.hit_way(hit_way)
);

/* Buffer for swapping*/
register #(.width(128)) swap_buffer
(
    .clk(clk),
    .load(load_buffer),
    .in(datamux_out),
    .out(buffer_out)
);


/*  Muxes */
mux2 #(.width(128)) rdatamux
(
	.sel(rdatamux_sel),
	.a(pmem_rdata_in), 
	.b(buffer_out),
	
	.f(rdata_out)
);

mux2 #(.width(2)) waymux
(
	.sel(waymux_sel),
	.a(lru_way), 
	.b(swap_way),
	
	.f(waymux_out)
);

mux4 #(.width(128)) datamux
(
	.sel(waymux_out),
	.a(data_out_A), 
	.b(data_out_B),
	.c(data_out_C),
	.d(data_out_D),
	
	.f(datamux_out)
);

mux4 #(.width(12)) tagmux
(
	.sel(waymux_out),
	.a(tag_out_A), 
	.b(tag_out_B),
	.c(tag_out_C),
	.d(tag_out_D),
	
	.f(tagmux_out)
);

mux4 #(.width(1)) dirtymux
(
	.sel(waymux_out),
	.a(dirty_out_A), 
	.b(dirty_out_B),
	.c(dirty_out_C),
	.d(dirty_out_D),
	
	.f(dirty)
);

mux2 #(.width(16)) pmem_addressmux
(
	.sel(pmem_addressmux_sel),
	.a(l2_address), 
	.b({tagmux_out , l2_offset}),
	
	.f(pmem_address)
);


assign pmem_wdata = datamux_out;

endmodule : cache_datapath_vc

