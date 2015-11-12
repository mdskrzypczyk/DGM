import lc3b_types::*;

/**
 *	The set for Data Array, Each set contain 8 cache lines 
 *	which each cache line is a register contain 8 words of data 
 */

module set(
	input clk,
	input load, //loading the cache line 
	input word_load,//loading a single word from the CPU
	input[1:0] byte_access, //indicate when a byte access is taking place, 01 --> lower byte, 10--> higher byte, 11--> both ,  00 --> none
	input[2:0] word_index, //the word index, which is the last 3 bits for an address
	//input set_sel, //set select signal 
	input[2:0] set_sel, //the set select 
	input line_sel , //1 bit select a line in the set 
	//input[2:0] line_sel, //3 bits selecting which cacheline to operate on 
	input lc3b_burst in, //burst data input 128bits 
	input lc3b_word word_in, //a word of data input 16 bits
	output lc3b_burst out, //burst data out to physical memory 
	output lc3b_burst out0, out1
	//output lc3b_burst out0, out1, out2, out3, out4, out5, out6, out7 //7 individual output for each cache lines
		
	);
	
	//2 way set associative 
//	lc3b_burst set0[7:0] ;//1st set of 8 cache lines  
//	lc3b_burst set1[7:0] ;//2nd set of 8 cache lines 
	
	// Fix into 2way 8 sets 
lc3b_burst set0[1:0] ;
lc3b_burst set1[1:0] ;
lc3b_burst set2[1:0] ;
lc3b_burst set3[1:0] ;
lc3b_burst set4[1:0] ;
lc3b_burst set5[1:0] ;
lc3b_burst set6[1:0] ;
lc3b_burst set7[1:0] ;
	
	
	
	//initial values for all cache lines 
	initial 	
	begin 
		for(int i = 0; i < $size(set0); i++)
			begin 
//				set0[i] = 128'b0; //initial with all 0s
//				set1[i] = 128'b0; 
				set0[i] = 128'b0;
				set1[i] = 128'b0;
				set2[i] = 128'b0; 
				set3[i] = 128'b0; 
				set4[i] = 128'b0; 
				set5[i] = 128'b0; 
				set6[i] = 128'b0; 
				set7[i] = 128'b0; 
			end 
	end 
	
	always_ff @(posedge clk)
	begin 
		if(load == 1) //case loading the cache line from the memory as a burst 
			begin 
				case(set_sel) //checking which set it is operating on 
//					1'b0: 		set0[line_sel] = in; //loading with the selecting line 
//					1'b1:		set1[line_sel] = in; //loading with the selecting line 
					
					3'b000: set0[line_sel] = in;
					3'b001: set1[line_sel] = in;
					3'b010: set2[line_sel] = in;
					3'b011: set3[line_sel] = in;
					3'b100: set4[line_sel] = in;
					3'b101: set5[line_sel] = in;
					3'b110: set6[line_sel] = in;
					3'b111: set7[line_sel] = in;
				endcase 
			end 
		
	  else if(word_load == 1) //case loading from the CPU as a byte 
			begin 
				case(set_sel) //checking which set it is operating on 
					3'b000: begin 
						case(byte_access)
							2'b01: //lower byte  
								case(word_index )
									3'b000:set0[line_sel][7:0]  = word_in[7:0];
									3'b001:set0[line_sel][23:16]  = word_in[7:0];
									3'b010:set0[line_sel][39:32]  = word_in[7:0];
									3'b011:set0[line_sel][55:48]  = word_in[7:0];
									3'b100:set0[line_sel][71:64]  = word_in[7:0];
									3'b101:set0[line_sel][87:80]  = word_in[7:0];
									3'b110:set0[line_sel][103:96]  = word_in[7:0];
									3'b111:set0[line_sel][119:112]  = word_in[7:0];
								endcase
							2'b10: //higher byte 
								case(word_index)
									3'b000:set0[line_sel][15:8]  = word_in[15:8];
									3'b001:set0[line_sel][31:24]  = word_in[15:8];
									3'b010:set0[line_sel][47:40]  = word_in[15:8];
									3'b011:set0[line_sel][63:56]  = word_in[15:8];
									3'b100:set0[line_sel][79:72]  = word_in[15:8];
									3'b101:set0[line_sel][95:88]  = word_in[15:8];
									3'b110:set0[line_sel][111:104]  = word_in[15:8];
									3'b111:set0[line_sel][127:120]  = word_in[15:8];
								endcase
							2'b11: //both bytes
								case(word_index)
									3'b000:set0[line_sel][15:0]  = word_in;
									3'b001:set0[line_sel][31:16]  = word_in;
									3'b010:set0[line_sel][47:32]  = word_in;
									3'b011:set0[line_sel][63:48]  = word_in;
									3'b100:set0[line_sel][79:64]  = word_in;
									3'b101:set0[line_sel][95:80]  = word_in;
									3'b110:set0[line_sel][111:96]  = word_in;
									3'b111:set0[line_sel][127:112]  = word_in;
							  endcase
						endcase
					end
					3'b001: begin 
						case(byte_access)
							2'b01: //lower byte  
								case(word_index )
									3'b000:set1[line_sel][7:0]  = word_in[7:0];
									3'b001:set1[line_sel][23:16]  = word_in[7:0];
									3'b010:set1[line_sel][39:32]  = word_in[7:0];
									3'b011:set1[line_sel][55:48]  = word_in[7:0];
									3'b100:set1[line_sel][71:64]  = word_in[7:0];
									3'b101:set1[line_sel][87:80]  = word_in[7:0];
									3'b110:set1[line_sel][103:96]  = word_in[7:0];
									3'b111:set1[line_sel][119:112]  = word_in[7:0];
								endcase
							2'b10: //higher byte 
								case(word_index)
									3'b000:set1[line_sel][15:8]  = word_in[15:8];
									3'b001:set1[line_sel][31:24]  = word_in[15:8];
									3'b010:set1[line_sel][47:40]  = word_in[15:8];
									3'b011:set1[line_sel][63:56]  = word_in[15:8];
									3'b100:set1[line_sel][79:72]  = word_in[15:8];
									3'b101:set1[line_sel][95:88]  = word_in[15:8];
									3'b110:set1[line_sel][111:104]  = word_in[15:8];
									3'b111:set1[line_sel][127:120]  = word_in[15:8];
								endcase
							2'b11: //both bytes
								case(word_index)
									3'b000:set1[line_sel][15:0]  = word_in;
									3'b001:set1[line_sel][31:16]  = word_in;
									3'b010:set1[line_sel][47:32]  = word_in;
									3'b011:set1[line_sel][63:48]  = word_in;
									3'b100:set1[line_sel][79:64]  = word_in;
									3'b101:set1[line_sel][95:80]  = word_in;
									3'b110:set1[line_sel][111:96]  = word_in;
									3'b111:set1[line_sel][127:112]  = word_in;
								endcase
						endcase
					end 
					3'b010: begin 
						case(byte_access)
							2'b01: //lower byte  
								case(word_index )
									3'b000:set2[line_sel][7:0]  = word_in[7:0];
									3'b001:set2[line_sel][23:16]  = word_in[7:0];
									3'b010:set2[line_sel][39:32]  = word_in[7:0];
									3'b011:set2[line_sel][55:48]  = word_in[7:0];
									3'b100:set2[line_sel][71:64]  = word_in[7:0];
									3'b101:set2[line_sel][87:80]  = word_in[7:0];
									3'b110:set2[line_sel][103:96]  = word_in[7:0];
									3'b111:set2[line_sel][119:112]  = word_in[7:0];
								endcase
							2'b10: //higher byte 
								case(word_index)
									3'b000:set2[line_sel][15:8]  = word_in[15:8];
									3'b001:set2[line_sel][31:24]  = word_in[15:8];
									3'b010:set2[line_sel][47:40]  = word_in[15:8];
									3'b011:set2[line_sel][63:56]  = word_in[15:8];
									3'b100:set2[line_sel][79:72]  = word_in[15:8];
									3'b101:set2[line_sel][95:88]  = word_in[15:8];
									3'b110:set2[line_sel][111:104]  = word_in[15:8];
									3'b111:set2[line_sel][127:120]  = word_in[15:8];
								endcase
							2'b11: //both bytes
								case(word_index)
									3'b000:set0[line_sel][15:0]  = word_in;
									3'b001:set2[line_sel][31:16]  = word_in;
									3'b010:set2[line_sel][47:32]  = word_in;
									3'b011:set2[line_sel][63:48]  = word_in;
									3'b100:set2[line_sel][79:64]  = word_in;
									3'b101:set2[line_sel][95:80]  = word_in;
									3'b110:set2[line_sel][111:96]  = word_in;
									3'b111:set2[line_sel][127:112]  = word_in;
								endcase
						endcase
					end 
					3'b011: begin 
						case(byte_access)
							2'b01: //lower byte  
								case(word_index )
									3'b000:set3[line_sel][7:0]  = word_in[7:0];
									3'b001:set3[line_sel][23:16]  = word_in[7:0];
									3'b010:set3[line_sel][39:32]  = word_in[7:0];
									3'b011:set3[line_sel][55:48]  = word_in[7:0];
									3'b100:set3[line_sel][71:64]  = word_in[7:0];
									3'b101:set3[line_sel][87:80]  = word_in[7:0];
									3'b110:set3[line_sel][103:96]  = word_in[7:0];
									3'b111:set3[line_sel][119:112]  = word_in[7:0];
								endcase
							2'b10: //higher byte 
								case(word_index)
									3'b000:set3[line_sel][15:8]  = word_in[15:8];
									3'b001:set3[line_sel][31:24]  = word_in[15:8];
									3'b010:set3[line_sel][47:40]  = word_in[15:8];
									3'b011:set3[line_sel][63:56]  = word_in[15:8];
									3'b100:set3[line_sel][79:72]  = word_in[15:8];
									3'b101:set3[line_sel][95:88]  = word_in[15:8];
									3'b110:set3[line_sel][111:104]  = word_in[15:8];
									3'b111:set3[line_sel][127:120]  = word_in[15:8];
								endcase
							2'b11: //both bytes
								case(word_index)
									3'b000:set3[line_sel][15:0]  = word_in;
									3'b001:set3[line_sel][31:16]  = word_in;
									3'b010:set3[line_sel][47:32]  = word_in;
									3'b011:set3[line_sel][63:48]  = word_in;
									3'b100:set3[line_sel][79:64]  = word_in;
									3'b101:set3[line_sel][95:80]  = word_in;
									3'b110:set3[line_sel][111:96]  = word_in;
									3'b111:set3[line_sel][127:112]  = word_in;
								endcase
						endcase
					end 
					3'b100: begin 
						case(byte_access)
							2'b01: //lower byte  
								case(word_index )
									3'b000:set4[line_sel][7:0]  = word_in[7:0];
									3'b001:set4[line_sel][23:16]  = word_in[7:0];
									3'b010:set4[line_sel][39:32]  = word_in[7:0];
									3'b011:set4[line_sel][55:48]  = word_in[7:0];
									3'b100:set4[line_sel][71:64]  = word_in[7:0];
									3'b101:set4[line_sel][87:80]  = word_in[7:0];
									3'b110:set4[line_sel][103:96]  = word_in[7:0];
									3'b111:set4[line_sel][119:112]  = word_in[7:0];
								endcase
							2'b10: //higher byte 
								case(word_index)
									3'b000:set4[line_sel][15:8]  = word_in[15:8];
									3'b001:set4[line_sel][31:24]  = word_in[15:8];
									3'b010:set4[line_sel][47:40]  = word_in[15:8];
									3'b011:set4[line_sel][63:56]  = word_in[15:8];
									3'b100:set4[line_sel][79:72]  = word_in[15:8];
									3'b101:set4[line_sel][95:88]  = word_in[15:8];
									3'b110:set4[line_sel][111:104]  = word_in[15:8];
									3'b111:set4[line_sel][127:120]  = word_in[15:8];
								endcase
							2'b11: //both bytes
								case(word_index)
									3'b000:set0[line_sel][15:0]  = word_in;
									3'b001:set4[line_sel][31:16]  = word_in;
									3'b010:set4[line_sel][47:32]  = word_in;
									3'b011:set4[line_sel][63:48]  = word_in;
									3'b100:set4[line_sel][79:64]  = word_in;
									3'b101:set4[line_sel][95:80]  = word_in;
									3'b110:set4[line_sel][111:96]  = word_in;
									3'b111:set4[line_sel][127:112]  = word_in;
								endcase
						endcase
					end 
					3'b101: begin 
						case(byte_access)
							2'b01: //lower byte  
								case(word_index )
									3'b000:set5[line_sel][7:0]  = word_in[7:0];
									3'b001:set5[line_sel][23:16]  = word_in[7:0];
									3'b010:set5[line_sel][39:32]  = word_in[7:0];
									3'b011:set5[line_sel][55:48]  = word_in[7:0];
									3'b100:set5[line_sel][71:64]  = word_in[7:0];
									3'b101:set5[line_sel][87:80]  = word_in[7:0];
									3'b110:set5[line_sel][103:96]  = word_in[7:0];
									3'b111:set5[line_sel][119:112]  = word_in[7:0];
								endcase
							2'b10: //higher byte 
								case(word_index)
									3'b000:set5[line_sel][15:8]  = word_in[15:8];
									3'b001:set5[line_sel][31:24]  = word_in[15:8];
									3'b010:set5[line_sel][47:40]  = word_in[15:8];
									3'b011:set5[line_sel][63:56]  = word_in[15:8];
									3'b100:set5[line_sel][79:72]  = word_in[15:8];
									3'b101:set5[line_sel][95:88]  = word_in[15:8];
									3'b110:set5[line_sel][111:104]  = word_in[15:8];
									3'b111:set5[line_sel][127:120]  = word_in[15:8];
								endcase
							2'b11: //both bytes
								case(word_index)
									3'b000:set5[line_sel][15:0]  = word_in;
									3'b001:set5[line_sel][31:16]  = word_in;
									3'b010:set5[line_sel][47:32]  = word_in;
									3'b011:set5[line_sel][63:48]  = word_in;
									3'b100:set5[line_sel][79:64]  = word_in;
									3'b101:set5[line_sel][95:80]  = word_in;
									3'b110:set5[line_sel][111:96]  = word_in;
									3'b111:set5[line_sel][127:112]  = word_in;
								endcase
						endcase
					end 
					3'b110: begin 
						case(byte_access)
							2'b01: //lower byte  
								case(word_index )
									3'b000:set6[line_sel][7:0]  = word_in[7:0];
									3'b001:set6[line_sel][23:16]  = word_in[7:0];
									3'b010:set6[line_sel][39:32]  = word_in[7:0];
									3'b011:set6[line_sel][55:48]  = word_in[7:0];
									3'b100:set6[line_sel][71:64]  = word_in[7:0];
									3'b101:set6[line_sel][87:80]  = word_in[7:0];
									3'b110:set6[line_sel][103:96]  = word_in[7:0];
									3'b111:set6[line_sel][119:112]  = word_in[7:0];
								endcase
							2'b10: //higher byte 
								case(word_index)
									3'b000:set6[line_sel][15:8]  = word_in[15:8];
									3'b001:set6[line_sel][31:24]  = word_in[15:8];
									3'b010:set6[line_sel][47:40]  = word_in[15:8];
									3'b011:set6[line_sel][63:56]  = word_in[15:8];
									3'b100:set6[line_sel][79:72]  = word_in[15:8];
									3'b101:set6[line_sel][95:88]  = word_in[15:8];
									3'b110:set6[line_sel][111:104]  = word_in[15:8];
									3'b111:set6[line_sel][127:120]  = word_in[15:8];
								endcase
							2'b11: //both bytes
								case(word_index)
									3'b000:set0[line_sel][15:0]  = word_in;
									3'b001:set6[line_sel][31:16]  = word_in;
									3'b010:set6[line_sel][47:32]  = word_in;
									3'b011:set6[line_sel][63:48]  = word_in;
									3'b100:set6[line_sel][79:64]  = word_in;
									3'b101:set6[line_sel][95:80]  = word_in;
									3'b110:set6[line_sel][111:96]  = word_in;
									3'b111:set6[line_sel][127:112]  = word_in;
								endcase
						endcase
					end 
					3'b111: begin 
						case(byte_access)
							2'b01: //lower byte  
								case(word_index )
									3'b000:set7[line_sel][7:0]  = word_in[7:0];
									3'b001:set7[line_sel][23:16]  = word_in[7:0];
									3'b010:set7[line_sel][39:32]  = word_in[7:0];
									3'b011:set7[line_sel][55:48]  = word_in[7:0];
									3'b100:set7[line_sel][71:64]  = word_in[7:0];
									3'b101:set7[line_sel][87:80]  = word_in[7:0];
									3'b110:set7[line_sel][103:96]  = word_in[7:0];
									3'b111:set7[line_sel][119:112]  = word_in[7:0];
								endcase
							2'b10: //higher byte 
								case(word_index)
									3'b000:set7[line_sel][15:8]  = word_in[15:8];
									3'b001:set7[line_sel][31:24]  = word_in[15:8];
									3'b010:set7[line_sel][47:40]  = word_in[15:8];
									3'b011:set7[line_sel][63:56]  = word_in[15:8];
									3'b100:set7[line_sel][79:72]  = word_in[15:8];
									3'b101:set7[line_sel][95:88]  = word_in[15:8];
									3'b110:set7[line_sel][111:104]  = word_in[15:8];
									3'b111:set7[line_sel][127:120]  = word_in[15:8];
								endcase
							2'b11: //both bytes
								case(word_index)
									3'b000:set7[line_sel][15:0]  = word_in;
									3'b001:set7[line_sel][31:16]  = word_in;
									3'b010:set7[line_sel][47:32]  = word_in;
									3'b011:set7[line_sel][63:48]  = word_in;
									3'b100:set7[line_sel][79:64]  = word_in;
									3'b101:set7[line_sel][95:80]  = word_in;
									3'b110:set7[line_sel][111:96]  = word_in;
									3'b111:set7[line_sel][127:112]  = word_in;
								endcase
						endcase
					end 	
				endcase
			end 
		
	end 
	
	always_comb
	begin 
		case(set_sel)
		/*
			1'b0: //case set 0 is selected 
				begin 
						out0 = set0[0];
						out1 = set0[1];
						out2 = set0[2];
						out3 = set0[3];
						out4 = set0[4];
						out5 = set0[5];
						out6 = set0[6];
						out7 = set0[7];
						out = set0[line_sel]; //output for pmem_wdata 
				end 
				
			1'b1: //case set 1 is selected 
				begin 
						out0 = set1[0];
						out1 = set1[1];
						out2 = set1[2];
						out3 = set1[3];
						out4 = set1[4];
						out5 = set1[5];
						out6 = set1[6];
						out7 = set1[7];
						out = set1[line_sel]; //output for pmem_wdata
				end 
				*/
					
					3'b000: begin 
						out0 = set0[0];
						out1 = set0[1];
						out = set0[line_sel];
					end 
					
					3'b001: begin 
						out0 = set1[0];
						out1 = set1[1];
						out = set1[line_sel];
					end 
					
					3'b010: begin 
						out0 = set2[0];
						out1 = set2[1];
						out = set2[line_sel];
					end 
					
					3'b011: begin
						out0 = set3[0];
						out1 = set3[1];
						out = set3[line_sel];
					end 
					
					3'b100: begin
						out0 = set4[0];
						out1 = set4[1];
						out = set4[line_sel];
					end 
					
					3'b101: begin
						out0 = set5[0];
						out1 = set5[1];
						out = set5[line_sel];
					end 
					
					3'b110: begin
						out0 = set6[0];
						out1 = set6[1];
						out = set6[line_sel];
					end 
					
					3'b111: begin
						out0 = set7[0];
						out1 = set7[1];
						out = set7[line_sel];
					end 
					
			
		endcase
	end 
	

endmodule : set 