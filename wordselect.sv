import lc3b_types::*;
module wordselect
(

	input lc3b_cache_offset offset,	//word offset input 
	input lc3b_burst data_burst,	//burst of data  from data array 
	output lc3b_word out	//word data given out into CPU

);

always_comb
begin
	out = 16'b0;
	case(offset[3:1])
		3'b000: begin
			out = data_burst[15:0];
		end
		3'b001: begin
			out = data_burst[31:16];
		end
		3'b010: begin
			out = data_burst[47:32];
		end
		3'b011: begin
			out = data_burst[63:48];
		end
		3'b100: begin
			out = data_burst[79:64];
		end
		3'b101: begin
			out = data_burst[95:80];
		end
		3'b110: begin
			out = data_burst[111:96];
		end
		3'b111: begin
			out = data_burst[127:112];
		end
		default: begin
			out = 16'b0;
		end
	endcase
end

endmodule : wordselect