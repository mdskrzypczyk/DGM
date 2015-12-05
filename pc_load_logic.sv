

module pc_load_logic
(
	input in,
	output logic load_pc
);

always_comb
begin
	load_pc = 1'b1;
end
endmodule : pc_load_logic