module reg_8 (input  logic Clk, Reset, Shift_In, Load, Shift_En,
              input  logic [7:0]  D,
              output logic Shift_Out,
              output logic [7:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 8'b0;
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
              output logic [8:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) 
			  Data_Out <= 9'b0;
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
    input logic Clk,Load_a,clr_ld, Shift_En,cleara, reset,
    input logic [8:0] A,
    input logic [7:0] B,
    output logic Shift_Out, 
    output logic [15:0] Data_Out,
    output logic X
);
    logic shift_ab, regb_out,shifta,shiftb,loada,loadb; 
	 logic [8:0] input_a;
	 logic [7:0] input_b;
	 
    reg_9 reg_a(.Clk(Clk),.Reset(cleara | reset),.Shift_In(Data_Out[15]),.Load(loada),.Shift_En(shifta),.D(input_a),.Shift_Out(shift_ab),.Data_Out({X,Data_Out[15:8]})); 
    reg_8 reg_b(.Clk(Clk),.Reset(reset),.Shift_In(shift_ab),.Load(loadb),.Shift_En(shiftb),.D(input_b),.Shift_Out(regb_out),.Data_Out(Data_Out[7:0]));
	 
	 always_comb
	 begin
		if(Load_a)
		begin 
			input_a = A; 
			input_b = B;
			shifta = 1'b0;
			shiftb = 1'b0;
			loada = 1'b1;
			loadb = 1'b0;
		end
		else if(clr_ld)
		begin 
			input_a = 9'b0; 
			input_b = B;
			shifta = 1'b0;
			shiftb = 1'b0;
			loada = 1'b1;
			loadb = 1'b1;
		end 
		else if(Shift_En)
		begin 
			input_a = A; 
			input_b = B;
			shifta = 1'b1;
			shiftb = 1'b1;
			loada = 1'b0;
			loadb = 1'b0;
		end
		else
		begin
			input_a = A; 
			input_b = B;
			shifta = 1'b0;
			shiftb = 1'b0;
			loada = 1'b0;
			loadb = 1'b0;		
		end
	 end
	 
    
endmodule 