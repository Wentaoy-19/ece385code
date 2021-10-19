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

);

endmodule 



module reg_8 (input  logic Clk, Reset, Shift_In, Load, Shift_En,
              input  logic [7:0]  D,
              output logic Shift_Out,
              output logic [7:0]  Data_Out);

    always_ff @ (posedge Clk or posedge Reset)
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




module control(
	input logic Reset,
	input logic ClearA_LoadB,
	input logic Clk, 
	input logic Run, 
	output logic Clr_Ld, 
	output logic Shift, 
	output logic Add, 
	output logic Sub,  
	input logic M
);

	enum logic[3:0] {c0,c1,c2,c3,c4,c5,c6,c7,reset,halt} curr_state, next_state; 
	
    always_ff @ (posedge Clk)  
    begin
        if (Reset)
            curr_state <= halt;
        else
            curr_state <= next_state;
    end 
	 
	always_comb 
	begin  
        unique case (curr_state) 
				halt: if(Run) 
							next_state = c0;
				c0 : next_state = c1; 
				c1 : next_state = c2; 
				c2 : next_state = c3;
				c3 : next_state = c4;
				c4 : next_state = c5; 
				c5 : next_state = c6; 
				c6 : next_state = c7;	
				c7 : next_state = halt; 			  
        endcase
		  
		  
		  
		  if( (M == 1'b1) )
		  begin 
		  
				if(curr_state == c7)
				begin 
					Add = 1'b0;
					Sub = 1'b1;
					Shift = 1'b1;
				end 
				
				else 
				begin
					Add = 1'b1;
					Sub = 1'b0;
					Shift = 1'b1;
				end
		  end 
		  
		  else
		  begin
				Shift = 1'b1;
				Add = 1'b0;
				Sub = 1'b0;
		  end
		  
		
	end 
	
	
	 
endmodule 


