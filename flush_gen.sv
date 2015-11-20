import lc3b_types::*;

module flush_gen(
	input [3:0] opcode,
	input branch_enable,
	input stall,
	
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
				if(branch_enable)
				begin
					flush = 1;
				end
			end
			op_jmp : 
				flush = 1;
			op_jsr :
				flush = 1;
			op_trap :
				flush = 1;
			default : ;
		endcase
	end 
end

endmodule : flush_gen