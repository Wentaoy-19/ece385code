module uni_reg #(N = 16) (
			input  logic Clk, Load,reset,
            input  logic [N-1:0]  D,
            output logic [N-1:0]  Data_Out
);
    always_ff @ (posedge Clk)
    begin
		if (reset)
			Data_Out <= N'b0;  // FIXME: have problem? 
		else if (Load) 
			Data_Out <= D;
        else 
        	Data_Out <= Data_Out;		 
    end
endmodule

// fortest

module reg_parallel_16 (
			input  logic Clk, Load,reset,
            input  logic [15:0]  D,
            output logic [15:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
		 if (reset)
			Data_Out <= 16'b0;
		else if (Load) 
			Data_Out <= D;
        else 
            Data_Out <= Data_Out;		 
    end
endmodule

module mux4to1bit16 (
		input [15:0] Din1,
		input [15:0] Din2,
		input [15:0] Din3,
		input [15:0] Din4,
		input [1:0] select,
		output logic [15:0] Dout);
	
	always_comb
		begin
			if (select == 2'b00)
				Dout = Din1;
			else if (select == 2'b01)
				Dout = Din2;
			else if (select == 2'b10)
				Dout = Din3;
			else
				Dout = Din4;
		end
endmodule



module mux2to1bit16 (
		input [15:0] Din1,
		input [15:0] Din2,
		input select,
		output logic [15:0] Dout);
	
	always_comb
		begin
			if (select == 1'b0)
				Dout = Din1;
			else
				Dout = Din2;
		end
endmodule



module counter16bit (
		input [15:0] Din,
		input logic Clk,
		output logic [15:0] Dout);
		
	always_ff @ (posedge Clk)
		begin
			Dout[0] <= Din[0] ^ 1'b1;
			Dout[1] <= Din[1] ^ Din[0];
			Dout[2] <= Din[1] & Din[0] ^ Din[2];
			Dout[3] <= Din[0]& Din[1]& Din[2]^ Din[3];
			Dout[4] <= Din[0]& Din[1]& Din[2]& Din[3]^ Din[4];
			Dout[5] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]^ Din[5];
			Dout[6] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]^ Din[6];
			Dout[7] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]^ Din[7];
			Dout[8] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]^ Din[8];
			Dout[9] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]^ Din[9];
			Dout[10] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]& Din[9]^ Din[10];
			Dout[11] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]& Din[9]& Din[10]^ Din[11];
			Dout[12] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]& Din[9]& Din[10]& Din[11]^ Din[12];
			Dout[13] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]& Din[9]& Din[10]& Din[11]& Din[12]^ Din[13];
			Dout[14] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]& Din[9]& Din[10]& Din[11]& Din[12]& Din[13]^ Din[14];
			Dout[15] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]& Din[9]& Din[10]& Din[11]& Din[12]& Din[13]& Din[14] ^ Din[15];
		end
	endmodule





module ripple_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);
	  logic C0,C1,C2 ;
	  four_bit_ra FRA0(.x(A[3:0]),.y(B[3:0]),.cin(0),.s(Sum[3:0]),.cout(C0));
	  four_bit_ra FRA1(.x(A[7:4]),.y(B[7:4]),.cin(C0),.s(Sum[7:4]),.cout(C1));
	  four_bit_ra FRA2(.x(A[11:8]),.y(B[11:8]),.cin(C1),.s(Sum[11:8]),.cout(C2));
	  four_bit_ra FRA3(.x(A[15:12]),.y(B[15:12]),.cin(C2),.s(Sum[15:12]),.cout(CO));

     
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

module full_adder(
    input x, input y, input cin,
    output logic s,
    output logic cout
);
    assign s = x ^ y ^ cin;
    assign cout = (x&y)|(y&cin)|(cin&x);
    
endmodule