`timescale 1ns/10ps
module mux8to1updated(d, s, y);
	input logic [7:0] d;
	input logic [2:0] s;
	output logic y;
	logic m1_out, m2_out;
	
	mux4to1 mux0 (.d(d[3:0]),.s(s[1:0]), .y(m1_out));
	mux4to1 mux1 (.d(d[7:4]),.s(s[1:0]), .y(m2_out));
	mux2to1 mux2	(.d0(m1_out), .d1(m2_out), .select(s[2]), .y(y));
endmodule