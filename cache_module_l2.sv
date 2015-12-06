import lc3b_types::*;

module cache_module_l2
(
	input clk,
	
	//Signals from CPU
	input mem_read,
	input mem_write,
	input lc3b_word mem_address,
	input lc3b_burst mem_wdata,
	input [1:0] mem_byte_enable,
	
	//Signals from Memory
	input pmem_resp,
	input lc3b_burst pmem_rdata,
	
	//Signals to CPU
	output mem_resp,
	output lc3b_burst mem_rdata,
	output lc3b_word read_miss_count, write_miss_count,
	
	//Signals to Memory
	output pmem_read,
	output pmem_write,
	output lc3b_word pmem_address,
	output lc3b_burst pmem_wdata
);

logic load_data;
logic load_valid;
logic load_dirty;
logic clear_dirty;
logic load_lru;
logic load_tag;
logic cache_in_sel;
logic tag_hit;
logic dirty;
logic valid;
logic pmem_addr_sel;
logic pmem_read_sig;

assign pmem_read = pmem_read_sig;

misscounter16 miss_counter(
	.read(mem_read),
	.write(mem_write),
	.pmem_read(pmem_read_sig),
	.read_miss(read_miss_count),
	.write_miss(write_miss_count)
);

cache_datapath_l2 CACHE_DATAPATH_l2
(
	.clk(clk),
	.load_data(load_data),
	.load_valid(load_valid),
	.load_dirty(load_dirty),
	.clear_dirty(clear_dirty),
	.load_lru(load_lru),
	.load_tag(load_tag),
	.cache_in_sel(cache_in_sel),
	.mem_byte_enable(mem_byte_enable),
	.mem_address(mem_address),
	.mem_wdata(mem_wdata),
	.pmem_rdata(pmem_rdata),
	.tag_hit(tag_hit),
	.valid(valid),
	.dirty(dirty),
	.mem_rdata(mem_rdata),
	.pmem_address(pmem_address),
	.pmem_addr_sel(pmem_addr_sel),
	.pmem_wdata(pmem_wdata)
);

cache_control_l2 CACHE_CONTROLLER_l2
(
	.clk(clk),
	.mem_write(mem_write),
	.mem_read(mem_read),
	.pmem_resp(pmem_resp),
	.tag_hit(tag_hit),
	.dirty(dirty),
	.valid(valid),
	.cache_in_sel(cache_in_sel),
	.mem_resp(mem_resp),
	.load_valid(load_valid),
	.load_dirty(load_dirty),
	.clear_dirty(clear_dirty),
	.load_tag(load_tag),
	.load_data(load_data),
	.load_lru(load_lru),
	.pmem_addr_sel(pmem_addr_sel),
	.pmem_write(pmem_write),
	.pmem_read(pmem_read_sig)
);

endmodule : cache_module_l2
