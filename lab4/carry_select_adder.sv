module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  logic c4,c8,c12;
	  logic c1,c2,c3,c5,c6,c7;
	  logic a1,a2,a3;
	  logic [3:0] m1,m2,m3,m4,m5,m6,m7;
	  
	  //right most unit
		four_bit_rad fra0(.A(A[3:0]), .B(B[3:0]), .cin(0), .s(Sum[3:0]), .cout(c4));
		
		//right second unit
		four_bit_rad fra1(.A(A[7:4]), .B(B[7:4]),. cin(0), .s(m2[3:0]), .cout(c1));
		four_bit_rad fra2(.A(A[7:4]), .B(B[7:4]),. cin(1), .s(m1[3:0]), .cout(c2));
		mux8to4 mux1(.A(m1[3:0]), .B(m2[3:0]), .select(c4), .s(Sum[7:4]));
		and_gate and1(.x(c2), .y(c4), .And(a1));
		or_gate or1(.x(c1), .y(a1), .Or(c8));
		
		//left second unit
		four_bit_rad fra3(.A(A[11:8]), .B(B[11:8]),. cin(0), .s(m4[3:0]), .cout(c3));
		four_bit_rad fra4(.A(A[11:8]), .B(B[11:8]),. cin(1), .s(m3[3:0]), .cout(c5));
		mux8to4 mux2(.A(m3[3:0]), .B(m4[3:0]), .select(c8), .s(Sum[11:8]));
		and_gate and2(.x(c5), .y(c8), .And(a2));
		or_gate or2(.x(c3), .y(a2), .Or(c12));
		
		//left most unit
		four_bit_rad fra5(.A(A[15:12]), .B(B[15:12]),. cin(0), .s(m7[3:0]), .cout(c6));
		four_bit_rad fra6(.A(A[15:12]), .B(B[15:12]),. cin(1), .s(m6[3:0]), .cout(c7));
		mux8to4 mux3(.A(m6[3:0]), .B(m7[3:0]), .select(c12), .s(Sum[15:12]));
		and_gate and3(.x(c7), .y(c12), .And(a3));
		or_gate or3(.x(c6), .y(a3), .Or(CO));

endmodule
		
		
		
	

module four_bit_rad
(
	input [3:0] A,
	input [3:0] B,
	input cin,
	output logic [3:0] s,
	output logic cout);

logic c0, c1, c2;

full_adder2 fa0(.x(A[0]), .y(B[0]), .cin(cin), .s(s[0]), .cout(c0));
full_adder2 fa1(.x(A[1]), .y(B[1]), .cin(c0 ), .s(s[1]), .cout(c1));
full_adder2 fa2(.x(A[2]), .y(B[2]), .cin(c1 ), .s(s[2]), .cout(c2));
full_adder2 fa3(.x(A[3]), .y(B[3]), .cin(c2 ), .s(s[3]), .cout(cout));

endmodule

//full adder for 1 bit
module full_adder2
(
	input x,
	input y,
	input cin,
	output logic s,
	output logic cout
);

	assign s = x ^ y ^ cin;
	assign cout = (x&y) | (y&cin) | (cin&x);

endmodule


// an AND gate
module and_gate
(
	input x,
	input y,
	output logic And
);

	assign And = x & y;

endmodule



// an OR gate
module or_gate
(
	input x,
	input y,
	output logic Or
);

	assign Or = x | y;

endmodule



// 8-to-4 multiplexer
module mux8to4
(
	input [3:0] A,
	input [3:0] B,
	input select,
	output logic [3:0] s
);

always_comb

	begin
		if(select == 1)
			s = A;
		else
			s = B;
	end
	
endmodule
