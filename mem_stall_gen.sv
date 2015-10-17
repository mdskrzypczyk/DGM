module mem_stall_gen(
	input mem_read,
	input mem_write,
	input mem_resp,
	input hold,
	
	output load_addr,
	output stall
);

always_comb
begin
	stall = 0;
	load_addr = 0;
	if(((mem_read || mem_write) && mem_resp == 0) || hold == 1)
		stall = 1;
	else if(mem_resp == 1 && hold == 1)
	begin
		stall = 1;
		load_addr = 1;
	end
end

endmodule : mem_stall_gen