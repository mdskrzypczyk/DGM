import lc3b_types::*;

module misscounter16(
	input logic read,
	input logic write,
	input logic pmem_read,
	output lc3b_word read_miss, write_miss
);

lc3b_word read_count, write_count;

initial
begin
	read_count = 16'h0;
	write_count = 16'h0;
end

always_ff @ (posedge pmem_read)
begin
	if(read)
		read_count = read_count + 16'h1;
	else if(write)
		write_count = write_count + 16'h1;
end

always_comb
begin
	read_miss = read_count;
	write_miss = write_count;
end

endmodule : misscounter16