module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */

    logic [2:0] COUTIN;
    logic [3:0] PG;
    logic [3:0] GG; 
    logic cout; ////// 
    logic PG_X;
    logic GG_X;
	 logic [2:0] COUTIN2; 



    four_bit_lookahead_adder FBLA0(.Cin(0),.A(A[3:0]),.B(B[3:0]),.Cout(COUTIN2[0]),.PG(PG[0]),.GG(GG[0]),.S(Sum[3:0]));
    four_bit_lookahead_adder FBLA1(.Cin(COUTIN[0]),.A(A[7:4]),.B(B[7:4]),.Cout(COUTIN2[1]),.PG(PG[1]),.GG(GG[1]),.S(Sum[7:4]));
    four_bit_lookahead_adder FBLA2(.Cin(COUTIN[1]),.A(A[11:8]),.B(B[11:8]),.Cout(COUTIN2[2]),.PG(PG[2]),.GG(GG[2]),.S(Sum[11:8]));
    four_bit_lookahead_adder FBLA3(.Cin(COUTIN[2]),.A(A[15:12]),.B(B[15:12]),.Cout(cout),.PG(PG[3]),.GG(GG[3]),.S(Sum[15:12]));
    lookahead_unit LHU(.Cin(0),.P(PG),.G(GG),.C(COUTIN),.Cout(CO),.PG(PG_X),.GG(GG_X));

     
endmodule

module four_bit_lookahead_adder(
    input Cin,
    input [3:0] A,
    input [3:0] B,
    output Cout,
    output PG,
    output GG,
    output [3:0] S
);
    logic [3:0] P;
    logic [3:0] G;
    logic [2:0] C;

    lookahead_unit LHU(.Cin(Cin),.P(P),.G(G),.C(C),.Cout(Cout),.PG(PG),.GG(GG));
    lookahead_fulladder FA0(.a(A[0]),.b(B[0]),.z(Cin),.s(S[0]),.p(P[0]),.g(G[0]));
    lookahead_fulladder FA1(.a(A[1]),.b(B[1]),.z(C[0]),.s(S[1]),.p(P[1]),.g(G[1]));
    lookahead_fulladder FA2(.a(A[2]),.b(B[2]),.z(C[1]),.s(S[2]),.p(P[2]),.g(G[2]));
    lookahead_fulladder FA3(.a(A[3]),.b(B[3]),.z(C[2]),.s(S[3]),.p(P[3]),.g(G[3]));
  
endmodule



module lookahead_unit(
    input Cin,
    input [3:0] P,
    input [3:0] G,
    output [2:0] C,
    output Cout,
    output PG,
    output GG
);
    assign C[0] = Cin&P[0] | G[0]; 
    assign C[1] = Cin&P[0]&P[1] | G[0]&P[1] | G[1];
    assign C[2] = Cin&P[0]&P[1]&P[2] | G[0]&P[1]&P[2] | G[1]&P[2] | G[2]; 
    assign Cout = Cin&P[0]&P[1]&P[2]&P[3] | G[0]&P[1]&P[2]&P[3] | G[1]&P[2]&P[3] | G[2]&P[3] | G[3] ; 

    assign PG = P[0]&P[1]&P[2]&P[3];
    assign GG = G[3] | G[2]&G[3] | G[1]&P[3]&P[2] | G[0]&P[3]&P[2]&P[1]; 
endmodule




module lookahead_fulladder(
	input a,
	input b,
	input z,
	output s,
	output p,
	output g
);
    assign s = a^b^z;
    assign p = a^b;
    assign g = a & b;

endmodule
