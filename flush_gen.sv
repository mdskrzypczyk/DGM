import lc3b_types::*;

module flush_gen(
	input [3:0] opcode,
	input [3:0] mem_opcode,
	input branch_enable,
	input stall,
	input lc3b_ipacket packet_in,
	
	output logic flush
);

always_comb
begin
	flush = 0;
	if(~stall)
	begin
		case(opcode)
			op_br : 
			begin
				if(branch_enable != packet_in.br_prediction)
				begin
					flush = 1;
				end
			end
			op_jmp : 
				flush = 1;
			op_jsr :
				flush = 1;
			default : ;
		endcase
		if(mem_opcode == op_trap)
			flush = 1;
	end 
end

endmodule : flush_gen