

/**
 *	The 8 way mux majorly used in cache design 
 */
 
module mux8 #(parameter width = 16)
(
	input logic [2:0] sel, //3 bits of select  
	input [width-1:0] a, b, c, d, e, f, g, h,
	output logic [width - 1:0] o
);

always_comb 
	case(sel)
		3'b000:	o = a; 
		3'b001:	o = b;
		3'b010:	o = c;
		3'b011:	o = d;
		3'b100:	o = e;
		3'b101:	o = f;
		3'b110:	o = g;
		3'b111:	o = h;
		
		default: $display("Incorrent Select bit ");
	
	endcase
	 
endmodule: mux8
