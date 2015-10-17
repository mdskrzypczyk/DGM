module mp3(
	input clk,
	input pmem_resp,
	input lc3b_word pmem_rdata,
	
	output pmem_read,
	output pmem_write,
	output lc3b_word pmem_address,
	output lc3b_burst pmem_wdata
);

endmodule : mp3