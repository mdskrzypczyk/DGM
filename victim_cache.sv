import lc3b_types::*;

module victim_cache
(
   input clk,
	
	//from arbiter
	input lc3b_word arbiter_address,
	
	//from l2 cache
   input read,
   input write,
   input [15:0] address,
   input [127:0] wdata,
	
	//from physical memory
	input logic pmem_resp,
	input lc3b_burst pmem_rdata,
	 
	// to l2 cache
   output logic resp,
   output lc3b_burst rdata,
	
	//to physical memory
	output logic pmem_read,
	output logic pmem_write,
	output lc3b_word pmem_address,
	output lc3b_burst pmem_wdata
);

/* Internal Signals */
logic rdatamux_sel,waymux_sel;
logic load_buffer, load_entry;
logic dirty;
logic swap, hit;

/* Datapath */
cache_datapath_vc datapath
(
	//Inputs
	.clk(clk),
	
	.arbiter_address(arbiter_address),
	
	.l2_address(address),
	.l2_wdata(wdata),
	
	.rdatamux_sel(rdatamux_sel),
	.waymux_sel(waymux_sel),
	.load_buffer(load_buffer),
	.load_entry(load_entry),
	
	.pmem_rdata_in(pmem_rdata),
	
	//Outputs
	.swap(swap),
	.dirty(dirty),
	
	.rdata_out(rdata),
	
	.pmem_address(pmem_address),
	.pmem_wdata(pmem_wdata)
);


/* Control */
cache_control_vc control
(
	/* Inputs */
	.clk(clk),
	
	.read(read),
	.write(write),
	
	.swap(swap),
	.dirty(dirty),
	
	.pmem_resp(pmem_resp),
	
	/* Outputs */
	.resp(resp),
	
	.rdatamux_sel(rdatamux_sel),
	.waymux_sel(waymux_sel),
	.load_buffer(load_buffer),
	.load_entry(load_entry),
	
	.pmem_read(pmem_read),
	.pmem_write(pmem_write)
	
);


endmodule: victim_cache
