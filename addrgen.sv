import lc3b_types::*;

module addrgen
(
	input lru,
	input pmem_address_sel,
	input lc3b_word mem_address,
	input lc3b_tag tag0,
	input lc3b_tag tag1,
	input lc3b_set set,
	output lc3b_word addrgen_out
);

always_comb
begin
	if (pmem_address_sel == 0)
	begin
		addrgen_out = mem_address;
	end
	else
	begin
		if (lru == 0)
			addrgen_out = {tag0, set, 5'b0};
		else
			addrgen_out = {tag1, set, 5'b0};
	end
end

endmodule : addrgen
