import lc3b_types::*;

/**
 *	The arbiter of cache design 
 *		The arbiter located in between of two parts of Level 1 cache, and level 2 cache 
 * 	It takes control for data input and output between level 1 and level 2 caches 
 *	The arbiter should be fully combinational logic 
 */
 
 module arbiter (
	/* inputs */
		/* input from IF cache */
		input lc3b_word IF_address,
		input logic IF_read,
		input logic IF_write,
		input lc3b_burst IF_wdata,
		
		/* input from MEM cache */
		input lc3b_word MEM_address,
		input logic MEM_read,
		input logic MEM_write,
		input lc3b_burst MEM_wdata,
		
		/* input from L2 cache */
		input logic l2_resp,
		input lc3b_burst l2_rdata,
		
		
	/* outputs */
		/* output to IF cache */
		output logic l2i_resp,
		output lc3b_burst l2i_rdata,
		/* output to MEM cache */
		output logic l2d_resp,
		output lc3b_burst l2d_rdata,
		/* output to L2 cache */
		output lc3b_word l2_address,
		output logic l2_read,
		output logic l2_write,
		output lc3b_burst l2_wdata 
 );
 
 
 
 
 /* The combinational logic made up arbiter */
always_comb
	begin 
	/* initial all signals */
	l2_read = 1'b0;
	l2_write = 1'b0;
	l2_address = 16'b0;
	l2_wdata = 128'b0;
	l2i_resp = 1'b0;
	l2i_rdata = 128'b0;
	l2d_resp = 1'b0;
	l2d_rdata = 128'b0;	
	
		/* first detecting which cache is trying to access L2 */
		if(((IF_read == 1) || (IF_write == 1)) && (MEM_read == 0) && (MEM_write == 0))
			begin //case IF cache doing operation 
				// assign outputs to L2 
				l2_read = IF_read;
				l2_write = IF_write;
				l2_address = IF_address;
				l2_wdata = IF_wdata;
				// assign output to IF cache 
				l2i_resp = l2_resp;
				l2i_rdata = l2_rdata;
			end 
		else if(MEM_read == 1 || MEM_write == 1)//all other conditions, operating MEM cache first 
			begin 
				//assign output to L2 
				l2_read = MEM_read;
				l2_write = MEM_write;
				l2_address = MEM_address;
				l2_wdata = MEM_wdata;
				// assign output to MEM cache 
				l2d_resp = l2_resp;
				l2d_rdata = l2_rdata;
			end 
			

	end 
 
 
 
 endmodule: arbiter 
 
 
 
 
 
 
 
 
 