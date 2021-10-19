module reg_8 (input  logic Clk, Reset, Shift_In, Load, Shift_En,
              input  logic [7:0]  D,
              output logic Shift_Out,
              output logic [7:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 8'h0;
		 else if (Load)
			  Data_Out <= D;
		 else if (Shift_En)
		 begin
			  //concatenate shifted in data to the previous left-most 3 bits
			  //note this works because we are in always_ff procedure block
			  Data_Out <= { Shift_In, Data_Out[7:1] }; 
	    end
    end
    assign Shift_Out = Data_Out[0];
endmodule

module reg_9 (input  logic Clk, Reset, Shift_In, Load, Shift_En,
              input  logic [8:0]  D,
              output logic Shift_Out,
              output logic [7:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) 
			  Data_Out <= 9'h0;
		 else if (Load)
			  Data_Out <= D;
		 else if (Shift_En)
		 begin
			  Data_Out <= { Data_Out[8], Data_Out[8:1] }; 
	    end
    end
    assign Shift_Out = Data_Out[0];

endmodule

module reg_unit(
    input logic Clk,Reset,Load, Shift_En, 
    input logic [8:0] A,
    input logic [7:0] B,
    output logic Shift_Out, 
    output logic [15:0] Data_Out
);
    logic shift_ab, regb_out; 
    reg_9 reg_a(.Clk(Clk),.Reset(Reset),.Shift_In(0),.Load(Load),.Shift_En(Shift_En),.D(A),.Shift_Out(shift_ab),.Data_Out(Data_Out[15:8])); 
    reg_8 reg_b(.Clk(Clk),.Reset(Reset),.Shift_In(shift_ab),.Load(Load),.Shift_En(Shift_En),.D(B),.Shift_Out(regb_out),.Data_Out(Data_Out[7:0]));
    
endmodule 