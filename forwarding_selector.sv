import lc3b_types::*;

module forwarding_selector 
(
	input mem_rdata,
	input mem_alu_data,
	input logic [3:0] op_mem,
	input wb_data,
	
	output lc3b_word mem_out,
	output lc3b_word wb_out
);

always_comb
begin
	//memory operation. Loaded with bbbb for debuging purposes
	case (op_mem)
	 op_add  : mem_out = mem_alu_data;
    op_and  : mem_out = mem_alu_data;
    op_br   : mem_out = 16'hbbbb;
    op_jmp  : mem_out = 16'hbbbb;
    op_jsr  : mem_out = 16'hbbbb; //TODO
    op_ldb  : mem_out = mem_rdata;
    op_ldi  : mem_out = mem_rdata;
    op_ldr  : mem_out = mem_rdata;
    op_lea  : mem_out = mem_rdata;
    op_not  : mem_out = mem_alu_data;
    op_rti  : mem_out = 16'hbbbb;
    op_shf  : mem_out = mem_rdata;
    op_stb  : mem_out = mem_rdata;
    op_sti  : mem_out = mem_rdata;
    op_str  : mem_out = mem_rdata;
    op_trap : mem_out = 16'hbbbb; //TODO
	 default : mem_out = 16'hbbbb;
	endcase;
	
	//wb operationm
	wb_out = wb_data;
end	
	

endmodule: forwarding_selector

