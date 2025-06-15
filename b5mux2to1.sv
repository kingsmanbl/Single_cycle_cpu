`timescale 1ns/10ps
module b5mux2to1(d0, d1, select, y);
	input logic[4:0] d0, d1;
	output logic[4:0] y;
	input logic select;
	
	genvar i;
	generate
		for(i = 0; i < 5; i++) begin : each5btmux2to1
			mux2to1 b5mux (.d0(d0[i]),.d1(d1[i]),.select(select),.y(y[i]));
		end
	endgenerate
	
endmodule