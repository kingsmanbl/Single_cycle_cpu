`timescale 1ns/10ps
module bit_alu_wo_flag (input_A, input_B, control, result, carry_in, carry_out);
	input logic [2:0] control;
	input logic input_A, input_B, carry_in;
	output logic result, carry_out;
	
	logic band, bor, bxor, AorS, btor;
	
	bt_full_adder full_adder(.a(input_A), .b(input_B), .cin(carry_in), .sum(AorS), .cout(carry_out));
	and #50 bit_and(band, input_A, input_B);
	xor #50 bit_xor(bxor, input_A, input_B);
	not #50 not1(bor, input_B);
	or #50 bit_or(btor, input_A, bor);
	
	mux8to1updated op_select(.d({1'b0, bxor, btor, band, AorS, AorS, 1'b0, input_B}), .s(control) ,.y(result));
endmodule