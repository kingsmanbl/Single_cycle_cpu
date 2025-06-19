`timescale 1ns/10ps

module D_FF_enabled (q, d, clk, enable, reset);
	output logic q;
	input d, clk, enable, reset;
	logic not_enable;
	logic d_after_mux;
	
	mux2to1 mdx(.d0(q), .d1(d), .select(enable), .y(d_after_mux));
	D_FF d_ff_base(.q(q),.d(d_after_mux),.reset,.clk);
	
endmodule