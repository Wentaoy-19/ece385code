module full_adder(
    input x, input y, input cin,
    output logic s,
    output logic cout
);
    assign s = x ^ y ^ cin;
    assign cout = (x&y)|(y&cin)|(cin&x);
    
endmodule

module four_bit_ra(
    input [3:0] x,
    input [3:0] y,
    input cin,
    output logic [3:0] s, 
    output logic cout
);
	logic c0,c1,c2;
    full_adder fa0(.x(x[0]), .y(y[0]), .cin(cin),.s(s[0]),.cout(c0));
	 full_adder fa1(.x(x[1]), .y(y[1]), .cin(c0),.s(s[1]),.cout(c1));
    full_adder fa2(.x(x[2]), .y(y[2]), .cin(c1),.s(s[2]),.cout(c2));
    full_adder fa3(.x(x[3]), .y(y[3]), .cin(c2),.s(s[3]),.cout(cout));
endmodule


module ADD_SUB9(
	input [7:0] A,
	input [7:0] B,
	input  fn,
	output [8:0] S  
);
    logic cout01,cout1x,coutx;
    logic [3:0] fns;

    assign fns = {fn,fn,fn,fn};

    four_bit_ra fa0(.x(A[3:0]),.y(fns ^ B[3:0]),.cin(fn),.s(S[3:0]),.cout(cout01));
    four_bit_ra fa1(.x(A[7:4]),.y(fns ^ B[7:4]),.cin(cout01),.s(S[7:4]),.cout(cout1x));
    full_adder fax(.x(A[7]), .y(fn ^ B[7]), .cin(cout1x),.s(S[8]),.cout(coutx));
endmodule




module arithmetic(
	input logic Clr_Ld,
	input logic Shift, 
	input logic Add, 
	input logic Sub,
	input logic cleara,
    input logic[7:0] S,
    input logic Clk, Reset,

    output logic [15:0] Sum,
    output logic M,
    output logic X
);

    logic fn;
    logic [7:0] A,B,C,D,regb_input;
    logic [8:0] MID;
	 logic shiftout;

	
	 assign A = MID[7:0];

    reg_unit register1(.Clk(Clk),.Load_a( Add || Sub),.clr_ld(Clr_Ld),.Shift_En(Shift),.cleara(cleara),.reset(Reset),.A(MID[8:0]),.B(S[7:0]),.Shift_Out(shiftout),.Data_Out({B,D}),.X(X));
    ADD_SUB9 Adder1(.A(B[7:0]),.B(S[7:0]),.fn(Sub),.S(MID[8:0]));
    assign Sum = {B,D};
	 assign M = Sum[0]; 

endmodule