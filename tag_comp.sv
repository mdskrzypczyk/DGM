import lc3b_types::*;
module tag_comp
(
	input lc3b_tag tag,
	input lc3b_tag tag0,
	input lc3b_tag tag1,
	output logic tag_hit,
	output logic tag0_hit,
	output logic tag1_hit
);

always_comb
begin
	tag_hit = 0;
	tag0_hit = 0;
	tag1_hit = 0;
	if(tag == tag0)
	begin
		tag_hit = 1;
		tag0_hit = 1;
	end
	else if (tag == tag1)
	begin
		tag_hit = 1;
		tag1_hit = 1;
	end
end

endmodule : tag_comp