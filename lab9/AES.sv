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
		INVMIXCOL1,
		INVMIXCOL2,
		INVMIXCOL3,
		INVMIXCOL4,
		
		INVSHIFTROW,
		LOOPADDRK,



		
		
	} AES_STATE, AES_NEXT_STATE;
	
	
	
	
	always_ff @(posedge CLK)
	begin
		if (RESET) begin
			AES_STATE <= WAIT;
			Loop_counter <=4'b0;
		end
		
		else begin
			state <= next_state;
			AES_STATE <= AES_NEXT_STATE;
			Loop_counter <= Loop_counter_next;
		end
	end

endmodule
