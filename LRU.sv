import lc3b_types::*;

/**
 *	The LRU bit array: 
 *		the LRU bit array keep track the order of the used cache lines from most current use to
 *	the least used cache line. 
 */
 
 module LRU(
 
	input clk,
	input load,	mem_resp,//loading new data into memory, need to change 
	input[2:0] set_sel, //tell which set it is on
	input new_sel, // the new hit cache line 
	input hit_sig, //hit signal 
	
	
	//output logic [2:0] line_sel	//output the index for which line it should be in
  output logic line_sel
 
 );
 
 
 //lc3b_word set0[7:0]; //1st set 
 //lc3b_word set1[7:0]; //2nd set
  	// Fix into 2way 8 sets 
lc3b_word set0[1:0] ;
lc3b_word set1[1:0] ;
lc3b_word set2[1:0] ;
lc3b_word set3[1:0] ;
lc3b_word set4[1:0] ;
lc3b_word set5[1:0] ;
lc3b_word set6[1:0] ;
lc3b_word set7[1:0] ;
	
 
 
 //initialization when the system start and nothing in the cache
 initial
 begin /*
		for(int i = 0; i < $size(set0); i++)
			begin 
					set0[i] = i;	//initialize them with a linear orde!!!
					set1[i] = i;	//0 - 7 with 0 the newest and 7 the oldest 
			end 
		line_sel = 7;*/
				set0[1] = 1'b1;
				set1[1] = 1'b1;
				set2[1] = 1'b1; 
				set3[1] = 1'b1; 
				set4[1] = 1'b1; 
				set5[1] = 1'b1; 
				set6[1] = 1'b1; 
				set7[1] = 1'b1; 
				set0[0] = 1'b0;
				set1[0] = 1'b0;
				set2[0] = 1'b0; 
				set3[0] = 1'b0; 
				set4[0] = 1'b0; 
				set5[0] = 1'b0; 
				set6[0] = 1'b0; 
				set7[0] = 1'b0; 
				line_sel = 1'b1;
				
				
 end 
 
 always_ff @(posedge clk)
	begin 
		case(set_sel) //chosing the set 

					3'b000: begin 
						if(hit_sig == 1)	//case when hit 
							begin 
								line_sel = new_sel;
							end 
						else 	//case not hit 
							begin 
								if(set0[0] == 1)
									begin 
										line_sel = 0;
									end 
								else 
									begin 
										line_sel = 1;
									end 
							end 
							
						if(load == 1 && hit_sig == 1)
							begin 
								for(int i = 0; i < $size(set0); i++)
									begin 
										if(i != new_sel)
											set0[i] = 1; //1 indicate old cache 
									end 
								set0[new_sel] = 0;	//0 indicate new cache 
							end 

						if(load == 1 && hit_sig == 0) //case a miss and need to replace 
							begin 
								for(int i = 0; i < $size(set0); i++)
									begin 
										if(set0[i] == 1)
											begin 
												set0[i] = 0;
												line_sel = i;
											end 
										else 
											set0[i] = 1;
									end 
							end 
							
					end 
						
					3'b001: begin
						if(hit_sig == 1)
							begin 
								line_sel = new_sel;
							end 
						else 
							begin 
								if(set1[0] == 1)
									begin 
										line_sel = 0;
									end 
								else 
									begin 
										line_sel = 1;
									end 
							end 
							
						if(load == 1 && hit_sig == 1)
							begin 
								for(int i = 0; i < $size(set1); i++)
									begin 
										if(i != new_sel)
											set1[i] = 1;
									end 
								set1[new_sel] = 0;
							
							end 
		
						if(load == 1 && hit_sig == 0) //case a miss and need to replace 
							begin 
								for(int i = 0; i < $size(set1); i++)
									begin 
										if(set1[i] == 1)
											begin 
												set1[i] = 0;
												line_sel = i;
											end 
										else 
											set1[i] = 1;
									end 
							end 						

					end
					
					3'b010: begin
						if(hit_sig == 1)
							begin 
								line_sel = new_sel;
							end 
							else 
							begin 
								if(set2[0] == 1)
									begin 
										line_sel = 0;
									end 
								else 
									begin 
										line_sel = 1;
									end 
							end 
							
						if(load == 1 && hit_sig == 1)
							begin 
								for(int i = 0; i < $size(set2); i++)
									begin 
										if(i != new_sel)
											set2[i] = 1;
									end 
								set2[new_sel] = 0;
							
							end 

						if(load == 1 && hit_sig == 0) //case a miss and need to replace 
							begin 
								for(int i = 0; i < $size(set2); i++)
									begin 
										if(set2[i] == 1)
											begin 
												set2[i] = 0;
												line_sel = i;
											end 
										else 
											set2[i] = 1;
									end 
							end 

							

					end
					
					3'b011: begin
						if(hit_sig == 1)
							begin 
								line_sel = new_sel;
							end 
							else 
							begin 
								if(set3[0] == 1)
									begin 
										line_sel = 0;
									end 
								else 
									begin 
										line_sel = 1;
									end 
							end 
							
						if(load == 1 && hit_sig == 1)
							begin 
								for(int i = 0; i < $size(set3); i++)
									begin 
										if(i != new_sel)
											set3[i] = 1;
									end 
								set3[new_sel] = 0;
							
							end 

							if(load == 1 && hit_sig == 0) //case a miss and need to replace 
							begin 
								for(int i = 0; i < $size(set3); i++)
									begin 
										if(set3[i] == 1)
											begin 
												set3[i] = 0;
												line_sel = i;
											end 
										else 
											set3[i] = 1;
									end 
							end 

							

					end
					
					3'b100: begin
						if(hit_sig == 1)
							begin 
								line_sel = new_sel;
							end 
							else 
							begin 
								if(set4[0] == 1)
									begin 
										line_sel = 0;
									end 
								else 
									begin 
										line_sel = 1;
									end 
							end 
							
						if(load == 1 && hit_sig == 1)
							begin 
								for(int i = 0; i < $size(set4); i++)
									begin 
										if(i != new_sel)
											set4[i] = 1;
									end 
								set4[new_sel] = 0;
							
							end 

						if(load == 1 && hit_sig == 0) //case a miss and need to replace 
							begin 
								for(int i = 0; i < $size(set4); i++)
									begin 
										if(set4[i] == 1)
											begin 
												set4[i] = 0;
												line_sel = i;
											end 
										else 
											set4[i] = 1;
									end 
							end 
							

					end
					
					3'b101: begin
						if(hit_sig == 1)
							begin 
								line_sel = new_sel;
							end 
							else 
							begin 
								if(set5[0] == 1)
									begin 
										line_sel = 0;
									end 
								else 
									begin 
										line_sel = 1;
									end 
							end 
							
						if(load == 1 && hit_sig == 1)
							begin 
								for(int i = 0; i < $size(set5); i++)
									begin 
										if(i != new_sel)
											set5[i] = 1;
									end 
								set5[new_sel] = 0;
							
							end 

						if(load == 1 && hit_sig == 0) //case a miss and need to replace 
							begin 
								for(int i = 0; i < $size(set5); i++)
									begin 
										if(set5[i] == 1)
											begin 
												set5[i] = 0;
												line_sel = i;
											end 
										else 
											set5[i] = 1;
									end 
							end 
							

					end
					
					3'b110: begin
						if(hit_sig == 1)
							begin 
								line_sel = new_sel;
							end 
							else 
							begin 
								if(set6[0] == 1)
									begin 
										line_sel = 0;
									end 
								else 
									begin 
										line_sel = 1;
									end 
							end 
							
						if(load == 1 && hit_sig == 1)
							begin 
								for(int i = 0; i < $size(set6); i++)
									begin 
										if(i != new_sel)
											set6[i] = 1;
									end 
								set6[new_sel] = 0;
							
							end 

							if(load == 1 && hit_sig == 0) //case a miss and need to replace 
							begin 
								for(int i = 0; i < $size(set6); i++)
									begin 
										if(set6[i] == 1)
											begin 
												set6[i] = 0;
												line_sel = i;
											end 
										else 
											set6[i] = 1;
									end 
							end 
							

					end
					
					3'b111: begin
						if(hit_sig == 1)
							begin 
								line_sel = new_sel;
							end 
							else 
							begin 
								if(set7[0] == 1)
									begin 
										line_sel = 0;
									end 
								else 
									begin 
										line_sel = 1;
									end 
							end 
							
						if(load == 1 && hit_sig == 1)
							begin 
								for(int i = 0; i < $size(set7); i++)
									begin 
										if(i != new_sel)
											set7[i] = 1;
									end 
								set7[new_sel] = 0;
							
							end 
		
						if(load == 1 && hit_sig == 0) //case a miss and need to replace 
							begin 
								for(int i = 0; i < $size(set7); i++)
									begin 
										if(set7[i] == 1)
											begin 
												set7[i] = 0;
												line_sel = i;
											end 
										else 
											set7[i] = 1;
									end 
							end 
							

					end
	
		
		
		
		
		endcase 
	end 
  
 endmodule: LRU