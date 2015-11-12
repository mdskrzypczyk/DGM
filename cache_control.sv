import lc3b_types::*;

module cache_control
(
	input clk,
	input mem_write,
	input mem_read,
	input pmem_resp,
	input tag_hit,
	input dirty,
	input valid,
	
	output logic mem_resp,
	output logic load_valid,
	output logic load_dirty,
	output logic clear_dirty,
	output logic load_tag,
	output logic load_data,
	output logic load_lru,
	output logic pmem_addr_sel,
	output logic pmem_write,
	output logic pmem_read,
	output logic cache_in_sel
);

enum int unsigned {
	cache_access,
	physical_read,
	physical_write
} state, next_state;

always_comb
begin : state_actions
	mem_resp = 0;
	load_valid = 0;
	load_dirty = 0;
	clear_dirty = 0;
	load_tag = 0;
	load_data = 0;
	load_lru = 0;
	pmem_addr_sel = 0;
	pmem_write = 0;
	pmem_read = 0;
	cache_in_sel = 0;
	case(state)
		cache_access: begin
			if(mem_read && valid && tag_hit)
			begin
				mem_resp = 1;
				load_lru = 1;
			end
			else if(mem_write && valid && tag_hit)
			begin
				mem_resp = 1;
				load_lru = 1;
				load_dirty = 1;
				load_data = 1;
				cache_in_sel = 1;
			end
		end
		physical_read: begin
			if(pmem_resp)
			begin
				load_data = 1;
				load_valid = 1;
				clear_dirty = 1;
			end
			load_tag = 1;
			pmem_read = 1;
		end
		physical_write: begin
			pmem_addr_sel = 1;
			pmem_write = 1;
		end
	endcase
end

always_comb
begin: next_state_logic
	next_state = state;
	case(state)
		cache_access: begin
			if ((valid == 0 || (tag_hit == 0 && dirty == 0)) && (mem_read == 1 || mem_write == 1))
				next_state = physical_read;
			else if(tag_hit == 0 && dirty == 1)
				next_state = physical_write;
			else
				next_state = cache_access;
		end
		physical_read: begin
			if(pmem_resp == 0)
				next_state = physical_read;
			else
				next_state = cache_access;
		end
		physical_write: begin
			if(pmem_resp == 0)
				next_state = physical_write;
			else
				next_state = physical_read;
		end
		default:
			next_state = cache_access;
	endcase
end

always_ff @(posedge clk)
begin : next_state_assignment
	state <= next_state;
end

endmodule : cache_control
