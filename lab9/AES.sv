/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);




	enum logic [4:0]{
		WAIT, 
		DONE,
		KEY_EXPANSION,
		INITIAL_ROUND,
		
		LOOP_INVSUB,
		LOOP_INVSHIFTROW,
		LOOP_INVMIXCOL1,
		LOOP_INVMIXCOL2,
		LOOP_INVMIXCOL3,
		LOOP_INVMIXCOL4,
		LOOP_ADDRK,
		
		INVSUB,
		INVSHIFTROW,
		ADDRK
		
	} AES_STATE, AES_NEXT_STATE;
	
	logic [3:0] loop_counter,loop_counter_next;
	
	
	
	always_ff @(posedge CLK)
	begin
		if (RESET) begin
			AES_STATE <= WAIT;
			loop_counter <=4'b0;
		end
		
		else begin
			AES_STATE <= AES_NEXT_STATE;
			loop_counter = loop_counter_next;
		end
	end
	
	
	
	
	always_comb 
	begin 
	
		AES_STATE = AES_NEXT_STATE; 
		loop_counter_next = loop_counter; 
		unique case(AES_STATE)
		
		WAIT: 
		begin 
			if(AES_START == 1'b1)
			begin
				AES_NEXT_STATE = KEY_EXPANSION;
				loop_counter_next = 4'b0;
			end
			else
				AES_NEXT_STATE = WAIT;
		end
		
		KEY_EXPANSION:
		begin 
			loop_counter_next = 4'b0;
			AES_NEXT_STATE = INITIAL_ROUND; 
		end
		
		INITIAL_ROUND:
			AES_NEXT_STATE = LOOP_INVSHIFTROW;
		
		LOOP_INVSHIFTROW:
			AES_NEXT_STATE = LOOP_INVSUB; 
		
		LOOP_INVSUB:
			AES_NEXT_STATE = LOOP_ADDRK; 
		
		LOOP_ADDRK:
			AES_NEXT_STATE = LOOP_INVMIXCOL1;
		
		LOOP_INVMIXCOL1:
			AES_NEXT_STATE = LOOP_INVMIXCOL2;
		
		LOOP_INVMIXCOL2:
			AES_NEXT_STATE = LOOP_INVMIXCOL3;
		
		LOOP_INVMIXCOL3:
			AES_NEXT_STATE = LOOP_INVMIXCOL4;
		
		LOOP_INVMIXCOL4:
		begin
			if(loop_counter == 4'd8)
				AES_NEXT_STATE = INVSHIFTROW; 
			else
				loop_counter_next = loop_counter + 4'b1;
				AES_NEXT_STATE = LOOP_INVSHIFTROW;
		end
		
		INVSHIFTROW:
			AES_NEXT_STATE = INVSUB;
		INVSUB:
			AES_NEXT_STATE = ADDRK; 
		ADDRK:
			AES_NEXT_STATE = DONE; 
			
		DONE:
		begin
			if(AES_START == 0)
				AES_NEXT_STATE = WAIT;
			else
				AES_NEXT_STATE = DONE;
		end
		
		default:
			AES_NEXT_STATE = WAIT;
		
		
		endcase 
	end
	
endmodule
