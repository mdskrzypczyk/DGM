import lc3b_types::*;

module comparison_module_vc
(
	input lc3b_tag_vc arbiter_tag,
	input lc3b_tag_vc l2_tag,
	input lc3b_tag_vc tag_out_A,
	input lc3b_tag_vc tag_out_B,
	input lc3b_tag_vc tag_out_C,
	input lc3b_tag_vc tag_out_D,
	
	output logic swap,
	//output logic hit,
	output logic [1:0] swap_way
	//output logic [1:0] hit_way
);

//Hit logic
/*
always_comb
begin 
	hit = 1'b0;
	hit_way = 2'b00;
	
	if(tag_out_A == l2_tag )
	begin
		hit = 1'b1;
		hit_way = 2'b00;
	end
	
	else if(tag_out_B == l2_tag )
	begin
		hit = 1'b1;
		hit_way = 2'b01;
	end
	
	else if(tag_out_C == l2_tag )
	begin
		hit = 1'b1;
		hit_way = 2'b10;
	end
	
	else if(tag_out_D == l2_tag )
	begin
		hit = 1'b1;
		hit_way = 2'b11;
	end 

end
*/

//Swap logic
always_comb
begin 
	swap = 1'b0;
	swap_way = 2'b00;
	
	if(tag_out_A == arbiter_tag )
	begin
		swap = 1'b1;
		swap_way = 2'b00;
	end
	
	else if(tag_out_B == arbiter_tag )
	begin
		swap = 1'b1;
		swap_way = 2'b01;
	end
	
	else if(tag_out_C == arbiter_tag )
	begin
		swap = 1'b1;
		swap_way = 2'b10;
	end
	
	else if(tag_out_D == arbiter_tag )
	begin
		swap = 1'b1;
		swap_way = 2'b11;
	end 

end

endmodule : comparison_module_vc
