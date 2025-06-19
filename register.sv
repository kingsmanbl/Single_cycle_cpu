`timescale 1ns/10ps

module register(in, out, reset, clk, enable);
	input logic [63:0] in;
	output logic [63:0] out;
	input logic enable, reset, clk;
	
	genvar i;
	
	generate
		for(i=0; i < 64; i++) begin : eachDff
			D_FF_enabled dff (.q(out[i]),.d(in[i]),.clk ,.enable(enable),.reset);
		end
	endgenerate
	
endmodule