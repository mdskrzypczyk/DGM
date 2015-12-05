module cache_control_vc
(
	input logic clk,
	
	//from l2 cache
   input logic read,
   input logic write,
	
	//from datapath
	input logic swap,
	input dirty,
	
	//from physical memory
	input logic pmem_resp,
	
	//to l2 cache
	output logic resp,

	//to datapath
	output logic rdatamux_sel,
	output logic waymux_sel,
	output logic load_buffer,
	output logic load_entry,
	output logic pmem_addressmux_sel,
	
	//to physical memory
	output logic pmem_read,
	output logic pmem_write
);

enum int unsigned {
	s_idle,
	
	//cache write with swap
	s_write_swap1,
	s_write_swap2,
	
	//cache write with no swap
	s_write_data,
	s_pmem_write,
	
	//cache read
	s_pmem_read
} state, next_state;

always_comb
begin : state_actions
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	resp = 1'b0;
	rdatamux_sel = 1'b0;
	waymux_sel = 1'b0;
	load_buffer = 1'b0;
	load_entry = 1'b0;
	pmem_addressmux_sel = 1'b0;

	case(state)	
	
	s_idle : begin
	end
	
	s_write_swap1 : begin
		load_buffer = 1'b1;
		load_entry = 1'b1;
		waymux_sel = 1'b1;
		resp = 1'b1;
	end
	
	s_write_swap2 : begin
		resp = 1'b1;
		rdatamux_sel = 1'b1;
	end
	
	s_write_data : begin
		resp = 1'b1;
		load_entry = 1'b1;
		waymux_sel = 1'b0;
	end
	
	s_pmem_write : begin
		pmem_write = 1'b1;
		waymux_sel = 1'b0;
		pmem_addressmux_sel = 1'b1;
	end
	
	s_pmem_read : begin
		pmem_read = 1'b1;
		
		if(pmem_resp == 1'b1)
		begin
			resp = 1'b1;
		end
	end
		
	default : begin
	end
	
	endcase
end

always_comb
begin: next_state_logic
	next_state = state;
	
	case(state)
	
	s_idle : begin
		//cache read
		if(read == 1'b1)
			next_state = s_pmem_read;
		//swap, or cache hit
		else if(swap == 1'b1 && write == 1'b1 )
			next_state = s_write_swap1;
		//write w/ no eviction
		else if(swap ==1'b0 && write == 1'b1 && dirty == 1'b0)
			next_state = s_write_data;
		//write w/ eviction
		else if(swap ==1'b0 && write == 1'b1 && dirty == 1'b1)
			next_state = s_pmem_write;
		
	end
	
	s_write_swap1 : begin
		next_state = s_write_swap2;
	end
	
	s_write_swap2 : begin
		next_state = s_idle;
	end
	
	s_write_data : begin
		next_state = s_idle;
	end
	
	s_pmem_write : begin
		if(pmem_resp == 1'b0)
			next_state = s_pmem_write;
		else
			next_state = s_write_data;
	end
	
	s_pmem_read : begin
		if(pmem_resp == 1'b0)
			next_state = s_pmem_read;
		else
			next_state = s_idle;
	end
		
	default : begin
	end
	
	endcase
end

always_ff @(posedge clk)
begin : next_state_assignment
	state <= next_state;
end


endmodule: cache_control_vc