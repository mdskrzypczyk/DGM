import lc3b_types::*;

module tag_array_vc(
	input clk,
	input load,
	input logic [1:0] way,
	input lc3b_tag_vc tag_in,
	
	output lc3b_tag_vc tag_out_A,
	output lc3b_tag_vc tag_out_B,
	output lc3b_tag_vc tag_out_C,
	output lc3b_tag_vc tag_out_D
);

/* Internal Registers */
lc3b_tag_vc tag_A;
lc3b_tag_vc tag_B;
lc3b_tag_vc tag_C;
lc3b_tag_vc tag_D; 

/* Setup */
initial
begin
		tag_A = 11'b0;
		tag_B = 11'b0;
		tag_C = 11'b0;
		tag_D = 11'b0;
end

/*Loading logic*/
always_ff @ (posedge clk)
begin
	if(load == 1'b1)
	begin
		case(way)
		
		2'b00 : begin
			tag_A = tag_in;
		end
		
		2'b01 : begin
			tag_B = tag_in;
		end
		
		2'b10 : begin
			tag_C = tag_in;
		end
		
		2'b11 : begin
			tag_D = tag_in;
		end
		
		default : begin
		end
		
		endcase
	end
		
end

/* Output Data */
always_comb
begin
	tag_out_A = tag_A;
	tag_out_B = tag_B;
	tag_out_C = tag_C;
	tag_out_D = tag_D;
end

endmodule: tag_array_vc