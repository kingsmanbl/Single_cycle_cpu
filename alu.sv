`timescale 1ns/10ps

module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);
	input [63:0] A, B;
	input [2:0] cntrl;
	output [63:0] result;
	output logic negative, zero, overflow, carry_out;
	logic[63:0] pass_b, and_result, or_result, xor_result, add_sub_result;
	genvar i;
	
	assign pass_b = B;
	
	bt_and bit_and(.a(A) ,.b(B) ,.result(and_result));
	bt_or bit_or(.a(A) ,.b(B) ,.result(or_result));
	bt_xor bit_xor(.a(A) ,.b(B) ,.result(xor_result));
	bt_64_full_adder bit_64_adder(.a(A),.b(B),.default_cin(cntrl[0]),.result(add_sub_result),.cout(carry_out),.overflow(overflow));
	
	generate
		for(i = 0; i < 64; i++) begin:each_mx
			mux8to1 mx (.a(pass_b[i]),.b(add_sub_result[i]) ,.c(add_sub_result[i]) ,.d(and_result[i]) ,.e(or_result[i]) ,.f(xor_result[i]) ,.s0(cntrl[0]) ,.s1(cntrl[1]) ,.s2(cntrl[2]) ,.final_result(result[i]));
		end
	endgenerate
	
	zero_detector zero_detection(.result(result),.zero_detected(zero));
	assign negative = result[63];
	
endmodule



// Test bench for ALU
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;
	initial begin
	
		$display("%t testing PASS_B operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		for (i=0; i<100; i++) begin
			A = 64'h0000000000000001; B = 64'h0000000000000001;
			#(delay);
			assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		end
		
		for (i=0; i<100; i++) begin
			A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF;
			#(delay);
			assert(result == 64'hFFFFFFFFFFFFFFFE && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);
		end
		
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		for (i=0; i<100; i++) begin
			A = 64'h0001000100010100; B = 64'h0010010000000001;
			#(delay);
		end
		
		$display("%t testing and", $time);
		cntrl = ALU_AND;
		for (i=0; i<100; i++) begin
			A = 64'h0001000100010100; B = 64'h0010010000000001;
			#(delay);
			assert(result == 0 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1);
		end
		
		$display("%t testing and", $time);
		cntrl = ALU_AND;
		for (i=0; i<100; i++) begin
			A = 64'h1111111111111111; B = 64'h1111111111111111;
			#(delay);
			assert(result == 64'h1111111111111111 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		end
		
		$display("%t testing or", $time);
		cntrl = ALU_OR;
		for (i=0; i<100; i++) begin
			A = 64'h1111111111111111; B = 64'h1111111111111111;
			#(delay);
			assert(result == 64'h1111111111111111 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 0);
		end
		
		$display("%t testing or", $time);
		cntrl = ALU_OR;
		for (i=0; i<100; i++) begin
			A = 64'h0000000000000001; B = 64'h1111111111111111;
			#(delay);
			assert(result == 64'h1111111111111111 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		end
	end
endmodule
