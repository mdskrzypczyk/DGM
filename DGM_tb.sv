module DGM_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
/*
logic a_mem_resp;
logic a_mem_read;
logic a_mem_write;
logic [1:0] a_mem_byte_enable;
logic [15:0] a_mem_address;
logic [15:0] a_mem_rdata;
logic [15:0] a_mem_wdata;

logic b_mem_resp;
logic b_mem_read;
logic b_mem_write;
logic [1:0] b_mem_byte_enable;
logic [15:0] b_mem_address;
logic [15:0] b_mem_rdata;
logic [15:0] b_mem_wdata;
*/

logic resp;
logic [127:0] rdata;
logic read;
logic write;
logic [15:0] address;
logic [127:0] wdata;


/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

//assign a_mem_write = 1'b0;
//assign a_mem_wdata = 16'h0;

//assign b_mem_byte_enable = 2'b11;

DGM the_pip(
	.clk(clk),
	.resp(resp),
	.rdata(rdata),
	.read(read),
	.write(write),
	.address(address),
	.wdata(wdata)
);

/*
magic_memory_dp memory
(
	 .clk(clk),
	 
	    // Port A 
    .read_a(a_mem_read),
    .write_a(a_mem_write),
    .wmask_a(a_mem_byte_enable),
    .address_a(a_mem_address),
    .wdata_a(a_mem_wdata),
    .resp_a(a_mem_resp),
    .rdata_a(a_mem_rdata),

    // Port B 
   .read_b(b_mem_read),
   .write_b(b_mem_write),
	.wmask_b(b_mem_byte_enable),
	.address_b(b_mem_address),
	.wdata_b(b_mem_wdata),
   .resp_b(b_mem_resp),
   .rdata_b(b_mem_rdata)
);*/

physical_memory the_memory(
	.clk(clk),
	.read(read),
	.write(write),
	.address(address),
	.wdata(wdata),
	.resp(resp),
	.rdata(rdata)
);

endmodule : DGM_tb
