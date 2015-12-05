import lc3b_types::*;

/**
 * The btb loading control module 
 * which gives signal to control module to indicate if need to load
 * may seperate different branches later 
 */

 module btb_load(
	input lc3b_ipacket ipacket,
	
	output logic load_btb 
 );
 
 
 always_comb
 begin 
	load_btb = 1'b0;
	if(ipacket.branch == 1'b1 && ipacket.btb_miss == 1'b1) //it's a branch and miss fetched 
		load_btb = 1'b1;
 end 
 
 
 endmodule: btb_load