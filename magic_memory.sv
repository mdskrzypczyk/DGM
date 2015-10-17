/*
 * Magic memory
 */
module magic_memory
(
    input clk,
    input read,
    input write,
    input [1:0] byte_enable,
    input [15:0] address,
    input [15:0] wdata,
    output logic resp,
    output logic [15:0] rdata
);

timeunit 1ns;
timeprecision 1ns;

logic [7:0] mem [0:2**$bits(address)-1];
logic [15:0] even_address;

/* Initialize memory contents from memory.lst file */
initial
begin
    $readmemh("memory.lst", mem);
end

/* Calculate even address */
assign even_address = {address[15:1], 1'b0};

always @(posedge read)
begin : mem_read
    rdata = {mem[even_address+1], mem[even_address]};
end : mem_read

always @(posedge write)
begin : mem_write
    if (byte_enable[1])
    begin
        mem[even_address+1] = wdata[15:8];
    end

    if (byte_enable[0])
    begin
        mem[even_address] = wdata[7:0];
    end
end : mem_write

/* Magic memory responds immediately */
assign resp = read | write;

endmodule : magic_memory