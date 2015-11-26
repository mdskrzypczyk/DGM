module register_lru_vc #(parameter width = 16)
(
    input clk,
    input load,
    input [width-1:0] in,
	 input [width-1:0] init,
    output logic [width-1:0] out
);

logic [width-1:0] data;

/* Altera device registers are 0 at power on. Specify this
 * so that Modelsim works as expected.
 */
initial
begin
    data = init;
end

always_ff @(posedge clk)
begin
    if (load)
    begin
        data = in;
    end
end

always_comb
begin
    out = data;
end

endmodule : register_lru_vc
