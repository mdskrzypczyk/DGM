import lc3b_types::*;


/**
 * The 4 bit array which used for btb management 
 */

 module fourbitarray(
	input clk,
	input load,
	input clear,
	input lc3b_pc_ways btb_lru,
	input lc3b_set load_set, read_set,
	output logic outbit0, outbit1, outbit2, outbit3
 );
 
 
 /* the BTB has 4 ways and 16 sets */
 logic bit0[15:0];
 logic bit1[15:0];
 logic bit2[15:0];
 logic bit3[15:0];
 
 
 initial 
 begin 
	for(int i = 0; i < $size(bit0); i++)
	begin 
		bit0[i] = 1'b0;
		bit1[i] = 1'b0;
		bit2[i] = 1'b0;
		bit3[i] = 1'b0;
	end 
 end 
 
 
 always_ff @ (posedge clk)
 begin 
	if(load == 1) //case loading the bit according to the lru
	begin 
		case(btb_lru)
			2'b00:	bit0[load_set] = 1;
			2'b01:	bit1[load_set] = 1;
			2'b10:	bit2[load_set] = 1;
			2'b11:	bit3[load_set] = 1;
		endcase
	end 
/*	if(clear == 1) //case clearing a specific bit 
	begin 
		case(btb_lru)
			2'b00:	bit0[load_set] = 0;
			2'b01:	bit1[load_set] = 0;
			2'b10:	bit2[load_set] = 0;
			2'b11:	bit3[load_set] = 0;
		endcase
	end */
 end 
 
 //constant output 
 always_comb
 begin 
	outbit0 = bit0[read_set];
	outbit1 = bit1[read_set];
	outbit2 = bit2[read_set];
	outbit3 = bit3[read_set];
 end 
 
 
 endmodule: fourbitarray 