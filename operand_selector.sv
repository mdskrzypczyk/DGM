import lc3b_types::*;

module operand_selector 
(
	input logic [1:0] curr_case,
	input mem_in,
	input wb_in,
	
	output lc3b_word opA,
	output lc3b_word opB
);

/* Logic about routing the mem data and the wb data. Case comes from hazard detection*/
always_comb 
begin
		
	case (curr_case)
	
		2'b00 : begin
			opA = mem_in;
			opB = mem_in;
		end
		
		2'b01 : begin
			opA = mem_in;
			opB = wb_in;
		end
		
		2'b10 : begin
			opA = wb_in;
			opB = mem_in;
		end
		
		2'b11 : begin
			opA = wb_in;
			opB = wb_in;
		end
	
	endcase

end

endmodule: operand_selector