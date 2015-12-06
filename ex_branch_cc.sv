import lc3b_types::*;

module ex_branch_cc(
	input clk,
	input logic [1:0] mem_res_bits, ex_res_bits,
	input logic [3:0] mem_opcode,
	//input logic res_sel,
	input lc3b_nzp ex_alu_nzp, ex_addr_nzp, mem_nzp,
	//input ex_res, mem_res,
	
	output lc3b_nzp cc
);

lc3b_nzp cc_reg;

initial
begin
	cc_reg = 3'b000;
end

always_ff @ (posedge clk)
begin

	case(mem_res_bits)
		2'b11: cc_reg = mem_nzp;
		default: begin
			if(mem_opcode != op_trap)
			begin
				case(ex_res_bits)
					2'b01: cc_reg = ex_alu_nzp;
					2'b10: cc_reg = ex_addr_nzp;
					default:cc_reg = cc_reg;
				endcase
			end
		end
	endcase
end

always_comb
begin
	cc = cc_reg;
end

endmodule : ex_branch_cc
