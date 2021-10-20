module control(
	input logic Reset,
	input logic ClearA_LoadB,
	input logic Clk, 
	input logic Run, 
	output logic Clr_Ld, 
	output logic Shift, 
	output logic Add, 
	output logic Sub,  
	output logic cleara,
	input logic M
);

	enum logic[4:0] {halt,idle,idle1,s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,load,start} curr_state,next_state;

	

	
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
			halt:
			begin
				if(Run)
					next_state = start;	
				else if(ClearA_LoadB)
					next_state = load;
				else
					next_state = halt;
			end
			load: next_state = halt;
			
			start : next_state = s0;
			s0: next_state = s1;
			s1: next_state = s2; 
			s2: next_state = s3; 
			s3: next_state = s4;
			s4: next_state = s5;
			s5: next_state = s6;
			s6: next_state = s7;
			s7: next_state = s8;
			s8: next_state = s9;
			s9: next_state = s10;
			s10: next_state = s11;
			s11: next_state = s12;
			s12: next_state = s13;
			s13: next_state = s14;
			s14: next_state = s15;
			s15: next_state = idle1;
			idle1 : 
			begin
				if(Run)
					next_state = idle1;
				else
					next_state = halt;
			end
//			idle : next_state = halt;
			default: next_state = curr_state;
		endcase  


		if(curr_state == halt) // if halt
		begin
			Clr_Ld = 1'b0;
			Add = 1'b0;
			Sub = 1'b0;
			Shift = 1'b0;
			cleara = 1'b0;

		end

		else if (curr_state == load) begin  //if load
			Clr_Ld = 1'b1;
			Add = 1'b0;
			Sub = 1'b0;
			Shift = 1'b0;	
			cleara = 1'b0;
		
		end
		else if(curr_state == start) begin 
			Clr_Ld = 1'b0;
			Add = 1'b0;
			Sub = 1'b0;
			Shift = 1'b0;
			cleara = 1'b1;
		end
		
		else if(curr_state == idle1)  begin
			Clr_Ld = 1'b0;
			Add = 1'b0;
			Sub = 1'b0;
			Shift = 1'b0;
			cleara = 1'b0;
			
		end
		                           //ADD/SUB case
		else if(
				(curr_state == s0 ||
				curr_state == s2 ||
				curr_state == s4 ||
				curr_state == s6 ||
				curr_state == s8 ||
				curr_state == s10 ||
				curr_state == s12 ||
				curr_state == s14) )
			begin
			
			if(M==1'b1)
			begin
				if(curr_state == s14) // if SUB
				begin
					Clr_Ld = 1'b0;
					Add = 1'b0;
					Sub = 1'b1;
					Shift = 1'b0;
			cleara = 1'b0;
	
				end
				
				else begin           // case: add
					Clr_Ld = 1'b0;
					Add = 1'b1;
					Sub = 1'b0;
					Shift = 1'b0;	
			cleara = 1'b0;
					
				end
			end
			
			else
			begin 
					Clr_Ld = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
					Shift = 1'b0;	
					cleara = 1'b0;
		
			end
			
		end
		else begin  // only shift
					Clr_Ld = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
					Shift = 1'b1;	
			cleara = 1'b0;
			
				end

	end
	
	
	 
endmodule 


