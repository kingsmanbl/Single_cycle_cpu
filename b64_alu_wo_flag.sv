`timescale 1ns/10ps
module b64_alu_wo_flag (input_A, input_B, control, result, carry_out1, carry_out2);
	input logic [63:0] input_A, input_B;
	input logic [2:0] control;
	output logic [63:0] result;
	output logic carry_out1, carry_out2;
	logic [63:0] inB_modified;
	logic [62:0] carry_connect;
	
	genvar i;
	generate
		for(i = 0; i < 64; i++) begin : eachBitXor
			xor bchange(inB_modified[i], control[0], input_B[i]);
		end
	endgenerate
	
	bit_alu_wo_flag b_alu_wo_flag0(.input_A(input_A[0]),.input_B(inB_modified[0]),.control(control),.result(result[0]),.carry_in(control[0]),.carry_out(carry_connect[0]));
	
	generate
		for(i = 1; i < 63; i++) begin : eachbtalu
			bit_alu_wo_flag bt_alus_wo_flag(.input_A(input_A[i]),.input_B(inB_modified[i]),.control(control),.result(result[i]),.carry_in(carry_connect[i-1]),.carry_out(carry_connect[i]));
		end
	endgenerate
	
	bit_alu_wo_flag b_alu_wo_flag63(.input_A(input_A[63]),.input_B(inB_modified[63]),.control(control),.result(result[63]),.carry_in(carry_connect[62]),.carry_out(carry_out1));
	assign carry_out2 = carry_connect[62];

endmodule