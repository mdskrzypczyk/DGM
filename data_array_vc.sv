import lc3b_types::*;

module data_array_vc(
	input clk,
	input load,
	input logic [1:0] way,
	input lc3b_burst data_in,
	
	output lc3b_burst data_out_A,
	output lc3b_burst data_out_B,
	output lc3b_burst data_out_C,
	output lc3b_burst data_out_D
);

/* Internal Registers */
lc3b_burst data_A;
lc3b_burst data_B;
lc3b_burst data_C;
lc3b_burst data_D; 

/* Setup */
initial
begin
		data_A = 128'b0;
		data_B = 128'b0;
		data_C = 128'b0;
		data_D = 128'b0;
end

/*Loading logic*/
always_ff @ (posedge clk)
begin
	if(load == 1'b1)
	begin 
		case(way)
		
		2'b00 : begin
			data_A = data_in;
		end
		
		2'b01 : begin
			data_B = data_in;
		end
		
		2'b10 : begin
			data_C = data_in;
		end
		
		2'b11 : begin
			data_D = data_in;
		end
		
		default : begin
		end
		
		endcase
	end
		
end

/* Output Data */
always_comb
begin
	data_out_A = data_A;
	data_out_B = data_B;
	data_out_C = data_C;
	data_out_D = data_D;
end

endmodule: data_array_vc