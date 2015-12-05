import lc3b_types::*;

module cache_datapath_l2(
	input clk,
	input load_data,
	input load_valid,
	input load_dirty,
	input load_lru,
	input load_tag,
	input clear_dirty,
	input cache_in_sel,
	input [1:0] mem_byte_enable,
	input lc3b_word mem_address,
	input lc3b_burst mem_wdata,
	input pmem_addr_sel,
	input lc3b_burst pmem_rdata,
	
	output logic tag_hit,
	output logic valid,
	output logic dirty,
	output lc3b_burst mem_rdata,
	output lc3b_word pmem_address,
	output lc3b_burst pmem_wdata
);

lc3b_burst cache_out1;
lc3b_burst cache_out2;
lc3b_burst cache_out;
lc3b_burst cache_wdata;
lc3b_burst cache_mux_out;
lc3b_tag_l2 tag0;
lc3b_tag_l2 tag1;
logic lru_out;
logic valid_bit0;
logic valid_bit1;
logic dirty_bit0;
logic dirty_bit1;
logic tag0_hit;
logic tag1_hit;

/* Data Array */
dataselect_l2 DATA_OUT_l2
(
	.sel0(tag0_hit),
	.sel1(tag1_hit),
	.lru(lru_out),
	.data0(cache_out1),
	.data1(cache_out2),
	.out(cache_out)	//this is the correct output with tag checked already 
);
data_array_l2 DATA_l2
(
	.clk(clk),
	.load(load_data),
	.tag0_hit(tag0_hit),
	.tag1_hit(tag1_hit),
	.lru(lru_out),
	.in(cache_mux_out),
	.set(mem_address[9:5]),
	.cache_out1(cache_out1),
	.cache_out2(cache_out2)
);

/*
wordselect_l2 DATASElECT_l2
(
	.offset(mem_address[3:0]),
	.data_burst(cache_out),
	.out(mem_rdata)
);*/
/*
replace_word_l2 DATA_REPLACE_l2
(
	.in(cache_out),
	.offset(mem_address[3:0]),
	.new_data(mem_wdata),
	.mem_byte_enable(mem_byte_enable),
	.out(cache_wdata)
);*/

mux2 #(.width(256)) CACHE_IN_MUX_l2
(
	.sel(cache_in_sel),
	.a(pmem_rdata),
	.b(mem_wdata),
	.f(cache_mux_out)
);

lru_l2 LRU_l2
(
	.clk(clk),
	.load(load_lru),
	.tag0_hit(tag0_hit),
	.tag1_hit(tag1_hit),
	.set(mem_address[9:5]),
	.lru_out(lru_out)
);

/* Valid Bit Array */
bitselect_l2 validselect_l2
(
	.sel0(tag0_hit),
	.sel1(tag1_hit),
	.lru(lru_out),
	.data0(valid_bit0),
	.data1(valid_bit1),
	.out(valid)
);
twobitarray_l2 VALID_BITS_l2
(
	.clk(clk),
	.load(load_valid),
	.clear(1'b0),
	.lru(lru_out),
	.tag0_hit(tag0_hit),
	.tag1_hit(tag1_hit),
	.set(mem_address[9:5]),
	.outbit0(valid_bit0),
	.outbit1(valid_bit1)
);

/* Dirty Bit Array */
dirtyselect_l2 DIRTY_l2
(
	.lru(lru_out),
	.dirty0(dirty_bit0),
	.dirty1(dirty_bit1),
	.dirty(dirty)
);

twobitarray_l2 DIRTY_BITS_l2
(
	.clk(clk),
	.load(load_dirty),
	.clear(clear_dirty),
	.lru(lru_out),
	.tag0_hit(tag0_hit),
	.tag1_hit(tag1_hit),
	.set(mem_address[9:5]),
	.outbit0(dirty_bit0),
	.outbit1(dirty_bit1)
);

/* Tag Array */
tag_comp_l2 TAG_COMP_l2
(
	.tag(mem_address[15:10]),
	.tag0(tag0),
	.tag1(tag1),
	.tag_hit(tag_hit),
	.tag0_hit(tag0_hit),
	.tag1_hit(tag1_hit)
);

tag_array_l2 TAG_ARRAY_l2
(
	.clk(clk),
	.load(load_tag),
	.lru(lru_out),
	.tag(mem_address[15:10]),
	.set(mem_address[9:5]),
	.tag_out0(tag0),
	.tag_out1(tag1)
);

addrgen_l2 PMEM_GEN_l2
(
	.lru(lru_out),
	.pmem_address_sel(pmem_addr_sel),
	.mem_address(mem_address),
	.tag0(tag0),
	.tag1(tag1),
	.set(mem_address[9:5]),
	.addrgen_out(pmem_address)
);

assign pmem_wdata = cache_out;
assign mem_rdata = cache_out;

endmodule : cache_datapath_l2