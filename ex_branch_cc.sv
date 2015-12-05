import lc3b_types::*;

module ex_branch_cc(
	input clk,
	input logic res_sel,
	input [3:0] mem_opcode,
	input lc3b_nzp ex_alu_nzp, ex_addr_nzp, mem_nzp,
	input ex_res, mem_res,
	
	output lc3b_nzp cc
);

lc3b_nzp cc_reg;

initial
begin
	cc_reg = 3'b000;
end

always_ff @ (posedge clk)
begin
	if(ex_res & res_sel & mem_opcode != op_trap)
		cc_reg = ex_alu_nzp;
	else if(ex_res & mem_opcode != op_trap)
		cc_reg = ex_addr_nzp;
	else if(mem_res)
		cc_reg = mem_nzp;
	else
		cc_reg = cc_reg;
end

always_comb
begin
	cc = cc_reg;
end

endmodule : ex_branch_cc