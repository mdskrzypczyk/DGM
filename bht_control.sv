import lc3b_types::*;

/**
 * The BHT control module 
 *		single stage, takes in ipacket from branch resolving stage 
 * and give out signals to branch history table 
*/


module bht_control(
	input lc3b_ipacket packet_in, //the ipacket from branch resolving stage 
	
	output logic load_bht, 
	output logic clear_bht
);

always_comb
begin 
	load_bht = 0;
	clear_bht = 0;
	if(packet_in.branch) //case it is a branch 
		load_bht = 1'b1;
	if(packet_in.btb_miss)//case btb missed 
		clear_bht = 1'b1;

end 




endmodule: bht_control