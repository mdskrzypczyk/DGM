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
	case(offset[4:1])
		4'b0000: begin
			out = data_burst[15:0];
		end
		4'b0001: begin
			out = data_burst[31:16];
		end
		4'b0010: begin
			out = data_burst[47:32];
		end
		4'b0011: begin
			out = data_burst[63:48];
		end
		4'b0100: begin
			out = data_burst[79:64];
		end
		4'b0101: begin
			out = data_burst[95:80];
		end
		4'b0110: begin
			out = data_burst[111:96];
		end
		4'b0111: begin
			out = data_burst[127:112];
		end
		
		//added with cache expansion
		4'b1000: begin
			out = data_burst[143:128];
		end
		4'b1001: begin
			out = data_burst[159:144];
		end
		4'b1010: begin
			out = data_burst[175:160];
		end
		4'b1011: begin
			out = data_burst[191:176];
		end
		4'b1100: begin
			out = data_burst[207:192];
		end
		4'b1101: begin
			out = data_burst[223:208];
		end
		4'b1110: begin
			out = data_burst[239:224];
		end
		4'b1111: begin
			out = data_burst[255:240];
		end
		
		default: begin
			out = 16'b0;
		end
	endcase
end

endmodule : wordselect