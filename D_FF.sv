`timescale 1ns/10ps

module D_FF (q, d, reset, clk);
	output reg q;
	input logic d, reset, clk;
	
	always_ff @(posedge clk) begin
		if (reset)
			q <= 0; // On reset, set to 0
		else
			q <= d; // Otherwise out = d
	end
endmodule