import lc3b_types::*;

module addr_dec(
	input [3:0] mem_opcode,
	input [1:0] ex_addr_sel, mem_addr_sel,
	output logic [1:0] addr_sel
);

always_comb
begin
   addr_sel = 2'b00;
	if(mem_opcode == op_trap)
		addr_sel = mem_addr_sel;
	else
		addr_sel = ex_addr_sel;
end

endmodule : addr_dec