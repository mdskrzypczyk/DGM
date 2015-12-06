import lc3b_types::*;

module forwarding_selector 
(
	input lc3b_word mem_rdata,
	input lc3b_word mem_alu_data,
	input lc3b_word mem_addrgen,
	//input logic [3:0] op_mem,
	input lc3b_word wb_data,
	input lc3b_ipacket mem_packet,
	input lc3b_ipacket wb_packet,
	
	output lc3b_word mem_out,
	output lc3b_word wb_out
);

always_comb
begin
	//memory operation. Loaded with bbbb for debuging purposes
	case (mem_packet.opcode)
	
	op_add  : begin
		mem_out = mem_alu_data;
	end
	
	op_and  : begin 
		mem_out = mem_alu_data;
	end 
	
   op_br   : begin
		mem_out = 16'hbbbb;
	end
	
   op_jmp  : begin
		mem_out = 16'hbbbb;
	end
	
   op_jsr  : begin
		mem_out = mem_packet.pc;
	end
	
   op_ldb  : begin
		mem_out = mem_rdata;
	end
	
   op_ldi  : begin
		mem_out = mem_rdata;
	end
	
   op_ldr  : begin
		mem_out = mem_rdata;
	end
	
   op_lea  : begin
		mem_out = mem_addrgen;
	end
	
   op_not  : begin
		mem_out = mem_alu_data;
	end
	
   op_x  : begin 
		mem_out = mem_alu_data;
	end
	
   op_shf  : begin
		mem_out = mem_alu_data;
	end
	
   op_stb  : begin
		mem_out = mem_rdata;
	end
	
   op_sti  : begin
		mem_out = mem_rdata;
	end
	
   op_str  : begin
		mem_out = mem_rdata;
	end
	
   op_trap : begin
		mem_out = mem_rdata;
	end
	
	default : begin
		mem_out = 16'hbbbb;
	end
	endcase;
	
	//wb operation. Loaded with bbbb for debuging purposes
	case (wb_packet.opcode)
	
	op_add  : begin
		wb_out = wb_data;
	end
	
	op_and  : begin 
		wb_out = wb_data;
	end 
	
   op_br   : begin
		wb_out = wb_data;
	end
	
   op_jmp  : begin
		wb_out = wb_data;
	end
	
   op_jsr  : begin
		wb_out = wb_packet.pc;
	end
	
   op_ldb  : begin
		wb_out = wb_data;
	end
	
   op_ldi  : begin
		wb_out = wb_data;
	end
	
   op_ldr  : begin
		wb_out = wb_data;
	end
	
   op_lea  : begin
		wb_out = wb_data;
	end
	
   op_not  : begin
		wb_out = wb_data;
	end
	
   op_x  : begin 
		wb_out = wb_data;
	end
	
   op_shf  : begin
		wb_out = wb_data;
	end
	
   op_stb  : begin
		wb_out = wb_data;
	end
	
   op_sti  : begin
		wb_out = wb_data;
	end
	
   op_str  : begin
		wb_out = wb_data;
	end
	
   op_trap : begin
		wb_out = wb_packet.pc;
	end
	
	default : begin
		wb_out = wb_data;
	end
	endcase;	
	
end	
	

endmodule: forwarding_selector

