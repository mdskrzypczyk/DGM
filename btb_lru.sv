import lc3b_types::*;

/**
 * The BTB lru, which keeps in track the most recently used element
 * in the 4 ways of btb structure. 
 */
 
 // lru only being loaded (changed) when a hit or a store on the btb 
 // miss will not influence the operation and order
 
module btb_lru(
	input clk,
	input load, 
	input tag0_hit, tag1_hit, tag2_hit, tag3_hit,
	input store,
	input lc3b_set set, 
	output logic[1:0] btb_lru_out //2 bit lru out select 1 out of 4
	
);

/* initialize arrays for lru bits */
int lru_bits0[15:0];
int lru_bits1[15:0];
int lru_bits2[15:0];
int lru_bits3[15:0];

/* initialize all lru arrays into 0 as most recently used 3 as least used */
initial 
begin 
for(int i = 0; i < $size(lru_bits0); i++)
	begin 
		lru_bits0[i] = 0;
		lru_bits1[i] = 1;
		lru_bits2[i] = 2;
		lru_bits3[i] = 3;
	end 
end 

/* lru loading logic */
always_ff @ (posedge clk)
begin 
	if(load) //case loading the lru 
	begin 
		if(store) //case it is a store
		begin //find 3 change to 0, everything else + 1 
			if(lru_bits0[set] == 3)
				lru_bits0[set] = 0;
			else 
				lru_bits0[set] = lru_bits0[set] + 1;
			if(lru_bits1[set] == 3)
				lru_bits1[set] = 0;
			else 
				lru_bits1[set] = lru_bits1[set] + 1;
			if(lru_bits2[set] == 3)
				lru_bits2[set] = 0;
			else 
				lru_bits2[set] = lru_bits2[set] + 1;
			if(lru_bits3[set] == 3)
				lru_bits3[set] = 0;
			else 
				lru_bits3[set] = lru_bits3[set] + 1;
		end
	  //rest case are hit 
	  if(tag0_hit)//case tag0 hit
	  begin 
		if(lru_bits1[set] < lru_bits0[set])
			lru_bits1[set] = lru_bits1[set] + 1;
		if(lru_bits2[set] < lru_bits0[set])
			lru_bits2[set] = lru_bits2[set] + 1;
		if(lru_bits3[set] < lru_bits0[set])
			lru_bits3[set] = lru_bits3[set] + 1;	
		lru_bits0[set] = 0;
	  end 
	  if(tag1_hit) //case tag1 hit
	  begin 
		if(lru_bits0[set] < lru_bits1[set])
			lru_bits0[set] = lru_bits0[set] + 1;
		if(lru_bits2[set] < lru_bits1[set])
			lru_bits2[set] = lru_bits2[set] + 1;
		if(lru_bits3[set] < lru_bits1[set])
			lru_bits3[set] = lru_bits3[set] + 1;
		lru_bits1[set] = 0;
	  end 
	  if(tag2_hit) //case tag2 hit
	  begin 
		if(lru_bits0[set] < lru_bits2[set])
			lru_bits0[set] = lru_bits0[set] + 1;
		if(lru_bits1[set] < lru_bits2[set])
			lru_bits1[set] = lru_bits1[set] + 1;
		if(lru_bits3[set] < lru_bits2[set])
			lru_bits3[set] = lru_bits3[set] + 1;
		lru_bits2[set] = 0;
	  end 
	  if(tag3_hit) //case tag3 hit
	  begin 
		if(lru_bits0[set] < lru_bits3[set])
			lru_bits0[set] = lru_bits0[set] + 1;
		if(lru_bits1[set] < lru_bits3[set])
			lru_bits1[set] = lru_bits1[set] + 1;
		if(lru_bits2[set] < lru_bits3[set])
			lru_bits2[set] = lru_bits2[set] + 1;
		lru_bits3[set] = 0;
	  end 
	end 
end 

//btb_lur output combinational logic 
always_comb
begin 
	btb_lru_out = 2'b00;
	if(lru_bits0[set] == 0)
		btb_lru_out = 2'b00;
	else if (lru_bits1[set] == 0)
		btb_lru_out = 2'b01;
	else if (lru_bits2[set] == 0)
		btb_lru_out = 2'b10;
	else if (lru_bits3[set] == 0)
		btb_lru_out = 2'b11;
end 



endmodule: btb_lru