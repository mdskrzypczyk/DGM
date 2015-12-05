import lc3b_types::*;

module address_parser_vc
(
	input lc3b_word arbiter_address,
	input lc3b_word l2_address,
	
	output lc3b_tag_vc arbiter_tag,
	output lc3b_cache_offset arbiter_offset,
	output lc3b_tag_vc l2_tag,
	output lc3b_cache_offset l2_offset
);

always_comb
begin

	arbiter_tag = arbiter_address[15:4];
	arbiter_offset = arbiter_address[3:0];
	
	l2_tag = l2_address[15:4];
	l2_offset = l2_address[3:0];
end


	

endmodule: address_parser_vc
