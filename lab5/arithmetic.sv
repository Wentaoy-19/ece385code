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
    full_adder fax(.x(A[7]), .y(fn^B[7]), .cin(c2),.s(S[8]),.cout(coutx));
endmodule

module arithmetic(
	input logic Clr_Ld,
	input logic Shift, 
	input logic Add, 
	input logic Sub,
    input logic S[7:0],
    input logic Clk, Reset, fn,
    input logic Data_Current[15:0],

    output [15:0] Sum,
    output M,
    output X
);

    logic fn;
    logic [7:0] A,B;
    logic [7:0] AddA,AddB;
    logic [8:0] MID;

    assign Sum[15:0] = Data_Current[15:0];

    always_comb 
    begin
    if (Clr_Ld == 1'b1)
        begin
            assign A[7:0] = 2'b00000000;
            assign B[7:0] = S[7:0];
            assign AddA[7:0] = Data_Current[15:8];
            assign AddB[7:0] = S[7:0];
            assign fn = 0;
        end
    else if (Shift == 1'b1)
        begin
            assign A[7:0] = Data_Current[15:0];
            assign B[7:0] = Data_Current[7:0];
            assign AddA[7:0] = Data_Current[15:8];
            assign AddB[7:0] = S[7:0];
            assign fn = 0;
        end
    else if (Add == 1'b1)
        begin
            assign A[7:0] = Data_Current[15:0];
            assign B[7:0] = Data_Current[7:0];
            assign AddA[7:0] = Data_Current[15:8];
            assign AddB[7:0] = S[7:0];
            assign fn = 0;
        end
    else if (Sub == 1'b1)
        begin
            assign A[7:0] = Data_Current[15:0];
            assign B[7:0] = Data_Current[7:0];
            assign AddA[7:0] = Data_Current[15:8];
            assign AddB[7:0] = S[7:0];
            assign fn = 1;
        end
    else
        begin
            assign A[7:0] = Data_Current[15:0];
            assign B[7:0] = Data_Current[7:0];
            assign AddA[7:0] = Data_Current[15:8];
            assign AddB[7:0] = S[7:0];
            assign fn = 0;
        end    
    end

    assign M = Sum[0];
    reg_unit register1(.Clk(Clk),.Reset(Clr_Ld),.Load(Clr_Ld),.Shift_En(Shift),.A(A[7:0]),.B(B[7:0]),.Shift_Out(M),.Data_Out(Sum[15:0]));
    ADD_SUB9 Adder1(.A(AddA[7:0]),.B(AddB[7:0]),.fn(fn),.S(MID[8:0]));
    assign Sum[15:8] = MID[7:0];
    assign X = MID[8];

endmodule