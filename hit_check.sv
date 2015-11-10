import lc3b_types::*;

/**
 *		The Tag hit/miss check module 
 *  Input : the tag from the address 
 *					8 tages from the tag set which is selected 
 *	output:
 *				Hit/Miss signal  
 *			 	index for the hit element 
 */
 
 module hit_check(
			input lc3b_tag add_tag, //the address tag for comparasion 
			input lc3b_tag tag0, tag1, //2 tags from the tag array 
			input v0, v1, //2 bits of valid array 
			
			output logic hit, //hit signal 1 for hit, 0 for miss 
			output logic index //1 bit output index for hit array 

 );
 

 
 
 always_comb
 begin 
 
	index = 1'b0;
   hit = 0;
 //doing compare 
 
	if(add_tag == tag0 && v0 ==1)
		begin 
			hit = 1;
			index = 0;
		end 
	else if(add_tag == tag1 && v1 == 1)
		begin 
			hit = 1;
			index = 1;
		end 
	else 
		begin 
			hit = 0;
		end 
 
 
 end 
 
 
 
 
 endmodule: hit_check