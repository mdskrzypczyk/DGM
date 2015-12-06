module dirty_array_vc(
	input clk,
	input load,
	input logic [1:0] way,
	input logic dirty_in,
	
	output logic dirty_out_A,
	output logic dirty_out_B,
	output logic dirty_out_C,
	output logic dirty_out_D
);

/* Internal Registers */
logic dirty_A;
logic dirty_B;
logic dirty_C;
logic dirty_D; 

/* Setup */
initial
begin
		dirty_A = 1'b0;
		dirty_B = 1'b0;
		dirty_C = 1'b0;
		dirty_D = 1'b0;
end

/*Loading logic*/
always_ff @ (posedge clk)
begin
	if(load == 1'b1)
	begin
		case(way)
		
		2'b00 : begin
			dirty_A = dirty_in;
		end
		
		2'b01 : begin
			dirty_B = dirty_in;
		end
		
		2'b10 : begin
			dirty_C = dirty_in;
		end
		
		2'b11 : begin
			dirty_D = dirty_in;
		end
		
		default : begin
		end
		
		endcase
	end
		
end

/* Output dirty */
always_comb
begin
	dirty_out_A = dirty_A;
	dirty_out_B = dirty_B;
	dirty_out_C = dirty_C;
	dirty_out_D = dirty_D;
end

endmodule: dirty_array_vc