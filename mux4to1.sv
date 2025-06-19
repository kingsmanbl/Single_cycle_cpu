`timescale 1ns/10ps

module mux4to1 (d, s, y);
	input [3:0] d;  
   input [1:0] s;          
   output logic y;      
	
   logic y1, y2;
	
   mux2to1 mux1 (.d0(d[0]), .d1(d[1]), .select(s[0]), .y(y1)); 
   mux2to1 mux2 (.d0(d[2]), .d1(d[3]), .select(s[0]), .y(y2)); 
   mux2to1 mux3 (.d0(y1), .d1(y2), .select(s[1]), .y(y));

endmodule