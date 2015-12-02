module lru_mux_logic(
	input logic [1:0] used_way,
	input logic [1:0] reg0_out,
	input logic [1:0] reg1_out,
	input logic [1:0] reg2_out,
	input logic [1:0] reg3_out,
	
	output logic mux1_sel,
	output logic mux2_sel,
	output logic mux3_sel
);


logic [1:0] hit; //variable deciding which of the registers got a hit

/* Hit logic */
always_comb
begin
	hit = 2'b00; 
	
	if(reg0_out == used_way)
		hit = 2'b00;
		
	else if(reg1_out == used_way)
		hit = 2'b01;
		
	else if(reg2_out == used_way)
		hit = 2'b10;
		
	else if(reg3_out == used_way)
		hit = 2'b11;
end

/* Logic for mux controls */
always_comb
begin
	mux1_sel = 1'b0;
	mux2_sel = 1'b0;
	mux3_sel = 1'b0;

	case(hit)
	2'b00 : begin
		mux1_sel = 1'b0;
		mux2_sel = 1'b0;
		mux3_sel = 1'b0;
	end
	
	2'b01 : begin
		mux1_sel = 1'b1;
		mux2_sel = 1'b0;
		mux3_sel = 1'b0;
	end
	
	2'b10 : begin
		mux1_sel = 1'b1;
		mux2_sel = 1'b1;
		mux3_sel = 1'b0;
	end
	
	2'b11 : begin
		mux1_sel = 1'b1;
		mux2_sel = 1'b1;
		mux3_sel = 1'b1;
	end
	
	default : begin
		mux1_sel = 1'b0;
		mux2_sel = 1'b0;
		mux3_sel = 1'b0;		
	end
	
	endcase

end


endmodule : lru_mux_logic