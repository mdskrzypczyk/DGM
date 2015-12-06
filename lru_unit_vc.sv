module lru_unit_vc(
	input logic clk,
	input logic load,
	input logic [1:0] used_way,
	
	output logic [1:0] lru_way

);

/*Internal signals*/
logic mux1_sel, mux2_sel, mux3_sel;
logic [1:0] mux1_out, mux2_out, mux3_out;
logic [1:0] reg0_out, reg1_out, reg2_out, reg3_out;

/* Lru Registers (arranged from most recently used to least)*/
register_lru_vc_3 #(.width(2)) reg0
(
    .clk(clk),
    .load(load),
    .in(used_way),
	 
    .out(reg0_out)
);

register_lru_vc_2 #(.width(2)) reg1
(
    .clk(clk),
    .load(load),
    .in(mux1_out),
	 
    .out(reg1_out)
);

register_lru_vc_1 #(.width(2)) reg2
(
    .clk(clk),
    .load(load),
    .in(mux2_out),
	 
    .out(reg2_out)
);

register_lru_vc #(.width(2)) reg3
(
    .clk(clk),
    .load(load),
    .in(mux3_out),
	 
    .out(reg3_out)
);

assign lru_way = reg3_out;

/* Muxes */

//No mux 0 since it will always be loaded with used way

mux2 #(.width(2)) mux1
(
	.sel(mux1_sel),
	.a(reg1_out), 
	.b(reg0_out),
	.f(mux1_out)
);

mux2 #(.width(2)) mux2
(
	.sel(mux2_sel),
	.a(reg2_out), 
	.b(reg1_out),
	.f(mux2_out)
);

mux2 #(.width(2)) mux3
(
	.sel(mux3_sel),
	.a(reg3_out), 
	.b(reg2_out),
	.f(mux3_out)
);


/* Mux control signals */
lru_mux_logic lru_mux_logic_unit
(
	.used_way(used_way),
	.reg0_out(reg0_out),
	.reg1_out(reg1_out),
	.reg2_out(reg2_out),
	.reg3_out(reg3_out),
	
	.mux1_sel(mux1_sel),
	.mux2_sel(mux2_sel),
	.mux3_sel(mux3_sel)
);

endmodule : lru_unit_vc
