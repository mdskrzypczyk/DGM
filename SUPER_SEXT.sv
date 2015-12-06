import lc3b_types::*;

/*
 *	The super sign extension module, which takes the max necessary input bits
 * and output the correct sign extened output into next stage 
 */
 
 module SUPER_SEXT(
	input lc3b_word in,	// The input signals that contains necessary bits 
	input [3:0] opcode, 	// The opcode of the specific operation to determine which signed extension bits to output 
	
	output lc3b_word out
 );
 
always_comb
	begin  
		out = 16'b0;
		case(opcode)
			//ADD imm5
			4'b0001:
				out = $signed({in[4:0]});  //SEXT(imm5)
			//AND imm5
			4'b0101:
				out = $signed({in[4:0]});  //SEXT(imm5)
			//BR PCoff9
			4'b0000:
				out = $signed({in[8:0], 1'b0}); //SEXT(PCoffset9) << 1
			//JSR PCoff11
			4'b0100:
				out = $signed({in[10:0], 1'b0}); //SEXT(PCoffset11) << 1
			//LDB off6
			4'b0010:
				out = $signed({in[5:0]});  //SEXT(offset6)
			//LDI off6
			4'b1010:
				out = $signed({in[5:0], 1'b0}); //SEXT(PCoffset6) << 1
			//LDR off6
			4'b0110:
				out = $signed({in[5:0], 1'b0}); //SEXT(PCoffset6) << 1
			//LEA PCoff9
			4'b1110:
				out = $signed({in[8:0], 1'b0}); //SEXT(PCoffset9) << 1
			//SHF imm4
			4'b1101:
				out = {12'b0,{in[3:0]}};  //SEXT(imm4)
			//STB off6
			4'b0011:
				out = $signed({in[5:0]});  //SEXT(offset6)
			//STI off6
			4'b1011:
				out = $signed({in[5:0], 1'b0}); //SEXT(PCoffset6) << 1
			//STR off6
			4'b0111:
				out = $signed({in[5:0], 1'b0}); //SEXT(PCoffset6) << 1
			//TRAP vect8
			4'b1111:
				out = {7'b0,in[7:0], 1'b0}; //ZEXT(PCoffset7) << 1
			default : ;
		endcase 
	
	end  
 
 
 
 endmodule : SUPER_SEXT 