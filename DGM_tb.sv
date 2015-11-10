import lc3b_types::*;

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

/* internal signals */
/*lc3b_word if_memaddr, if_mem_rdata, mem_memaddr, mem_mem_rdata, mem_mem_wdata;
logic [1:0] if_mem_byte_enable, mem_mem_byte_enable;
logic if_mem_resp, if_memread, mem_mem_resp, mem_memread, mem_memwrite;
*/

/*
 logic IF_read, IF_write, MEM_read, MEM_write, l2i_resp, l2d_resp;
 lc3b_word IF_address,  MEM_address;
 lc3b_burst l2i_rdata,IF_wdata, l2d_rdata, MEM_wdata ;
*/


DGM top(
		
	.clk(clk),
	.l2_resp(resp),
	.l2_rdata(rdata),
	.l2_address(address),
	.l2_read(read),
	.l2_write(write),
	.l2_wdata(wdata)
	
);

/*
DGM top(
	.clk(clk),
	.l2i_resp(l2i_resp),
	.l2i_rdata(l2i_rdata),
	.IF_address(IF_address),
	.IF_wdata(IF_wdata),
	.IF_read(IF_read),
	.IF_write(IF_write),
	
	.l2d_resp(l2d_resp),
	.l2d_rdata(l2d_rdata),
	.MEM_address(MEM_address),
	.MEM_wdata(MEM_wdata),
	.MEM_read(MEM_read),
	.MEM_write(MEM_write)


);
*/

/*
physical_memory IF_mem(
	.clk(clk),
	.read(IF_read),
	.write(IF_write),
	.address(IF_address),
	.wdata(IF_wdata),
	.resp(l2i_resp),
	.rdata(l2i_rdata)
);


physical_memory MEM_mem(
	.clk(clk),
	.read(MEM_read),
	.write(MEM_write),
	.address(MEM_address),
	.wdata(MEM_wdata),
	.resp(l2d_resp),
	.rdata(l2d_rdata)
);
*/


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
