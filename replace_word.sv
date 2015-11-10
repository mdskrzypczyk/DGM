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
	case(offset[3:1])
		3'b000 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[127:8], new_data[7:0]};
				2'b10:
					out = {in[127:16], new_data[15:8], in[7:0]};
				2'b11:
					out = {in[127:16], new_data};
				default:
					out = 128'b0;
			endcase
		end
		3'b001 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[127:24], new_data[7:0], in[15:0]};
				2'b10:
					out = {in[127:32], new_data[15:8], in[23:0]};
				2'b11:
					out = {in[127:32], new_data, in[15:0]};
				default:
					out = 128'b0;
			endcase
		end
		3'b010 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[127:40], new_data[7:0], in[31:0]};
				2'b10:
					out = {in[127:48], new_data[15:8], in[39:0]};
				2'b11:
					out = {in[127:48], new_data, in[31:0]};
				default:
					out = 128'b0;
			endcase
		end
		3'b011 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[127:56], new_data[7:0], in[47:0]};
				2'b10:
					out = {in[127:64], new_data[15:8], in[55:0]};
				2'b11:
					out = {in[127:64], new_data, in[47:0]};
				default:
					out = 128'b0;
			endcase
		end
		3'b100 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[127:72], new_data[7:0], in[63:0]};
				2'b10:
					out = {in[127:80], new_data[15:8], in[71:0]};
				2'b11:
					out = {in[127:80], new_data, in[63:0]};
				default:
					out = 128'b0;
			endcase
		end
		3'b101 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[127:88], new_data[7:0], in[79:0]};
				2'b10:
					out = {in[127:96], new_data[15:8], in[87:0]};
				2'b11:
					out = {in[127:96], new_data, in[79:0]};
				default:
					out = 128'b0;
			endcase
		end
		3'b110 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[127:104], new_data[7:0], in[95:0]};
				2'b10:
					out = {in[127:112], new_data[15:8], in[103:0]};
				2'b11:
					out = {in[127:112], new_data, in[95:0]};
				default:
					out = 128'b0;
			endcase
		end
		3'b111 : begin
			case(mem_byte_enable)
				2'b01:
					out = {in[127:120], new_data[7:0], in[111:0]};
				2'b10:
					out = {new_data[15:8], in[119:0]};
				2'b11:
					out = {new_data, in[111:0]};
				default:
					out = 128'b0;
			endcase
		end
		default: begin
			out = 128'b0;
		end
	endcase
end

endmodule : replace_word