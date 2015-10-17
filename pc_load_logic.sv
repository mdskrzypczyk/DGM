import lc3b_types::*;

module pc_load_logic
(
	input in,
	output load_pc
);

always_comb
begin
	load_pc = 1'b1;
end
endmodule : pc_load_logic