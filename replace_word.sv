import lc3b_types::*;
module replace_word
(
	input lc3b_burst in,
	input lc3b_cache_offset offset,
	input lc3b_word new_data,
	input [1:0] mem_byte_enable,
	output lc3b_burst out
);

always_comb
begin
	out = in;
	case(offset[4:1])
		4'b0000 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:8], new_data[7:0]};
				2'b10:
					out = {in[255:16], new_data[15:8], in[7:0]};
				2'b11:
					out = {in[255:16], new_data};
				default:
					out = 256'b0;
			endcase
		end
		4'b0001 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:24], new_data[7:0], in[15:0]};
				2'b10:
					out = {in[255:32], new_data[15:8], in[23:0]};
				2'b11:
					out = {in[255:32], new_data, in[15:0]};
				default:
					out = 256'b0;
			endcase
		end
		4'b0010 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:40], new_data[7:0], in[31:0]};
				2'b10:
					out = {in[255:48], new_data[15:8], in[39:0]};
				2'b11:
					out = {in[255:48], new_data, in[31:0]};
				default:
					out = 256'b0;
			endcase
		end
		4'b0011 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:56], new_data[7:0], in[47:0]};
				2'b10:
					out = {in[255:64], new_data[15:8], in[55:0]};
				2'b11:
					out = {in[255:64], new_data, in[47:0]};
				default:
					out = 256'b0;
			endcase
		end
		4'b0100 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:72], new_data[7:0], in[63:0]};
				2'b10:
					out = {in[255:80], new_data[15:8], in[71:0]};
				2'b11:
					out = {in[255:80], new_data, in[63:0]};
				default:
					out = 256'b0;
			endcase
		end
		4'b0101 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:88], new_data[7:0], in[79:0]};
				2'b10:
					out = {in[255:96], new_data[15:8], in[87:0]};
				2'b11:
					out = {in[255:96], new_data, in[79:0]};
				default:
					out = 256'b0;
			endcase
		end
		4'b0110 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:104], new_data[7:0], in[95:0]};
				2'b10:
					out = {in[255:112], new_data[15:8], in[103:0]};
				2'b11:
					out = {in[255:112], new_data, in[95:0]};
				default:
					out = 256'b0;
			endcase
		end
		4'b0111 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:120], new_data[7:0], in[111:0]};
				2'b10:
					out = {in[255:128],new_data[15:8], in[119:0]};
				2'b11:
					out = {in[255:128],new_data, in[111:0]};
				default:
					out = 256'b0;
			endcase
		end
		
		//added due to cache expansion
		4'b1000 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:136], new_data[7:0],in[127:0]};
				2'b10:
					out = {in[255:144], new_data[15:8], in[135:0]};
				2'b11:
					out = {in[255:144], new_data, in[127:0]};
				default:
					out = 256'b0;
			endcase
		end
		4'b1001 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:152], new_data[7:0], in[143:0]};
				2'b10:
					out = {in[255:160], new_data[15:8], in[151:0]};
				2'b11:
					out = {in[255:160], new_data, in[143:0]};
				default:
					out = 256'b0;
			endcase
		end
		4'b1010 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:168], new_data[7:0], in[159:0]};
				2'b10:
					out = {in[255:176], new_data[15:8], in[167:0]};
				2'b11:
					out = {in[255:176], new_data, in[159:0]};
				default:
					out = 256'b0;
			endcase
		end
		4'b1011 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:184], new_data[7:0], in[175:0]};
				2'b10:
					out = {in[255:192], new_data[15:8], in[183:0]};
				2'b11:
					out = {in[255:192], new_data, in[175:0]};
				default:
					out = 256'b0;
			endcase
		end
		4'b1100 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:200], new_data[7:0], in[191:0]};
				2'b10:
					out = {in[255:208], new_data[15:8], in[199:0]};
				2'b11:
					out = {in[255:208], new_data, in[191:0]};
				default:
					out = 256'b0;
			endcase
		end
		4'b1101 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:216], new_data[7:0], in[207:0]};
				2'b10:
					out = {in[255:224], new_data[15:8], in[215:0]};
				2'b11:
					out = {in[255:224], new_data, in[207:0]};
				default:
					out = 256'b0;
			endcase
		end
		4'b1110 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:232], new_data[7:0], in[223:0]};
				2'b10:
					out = {in[255:240], new_data[15:8], in[231:0]};
				2'b11:
					out = {in[255:240], new_data, in[223:0]};
				default:
					out = 256'b0;
			endcase
		end
		//edit
		4'b1111 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[255:248], new_data[7:0], in[239:0]};
				2'b10:
					out = {new_data[15:8], in[247:0]};
				2'b11:
					out = {new_data, in[239:0]};
				default:
					out = 256'b0;
			endcase
		end
		
		
		default: begin
			out = 256'b0;
		end
	endcase
end

endmodule : replace_word