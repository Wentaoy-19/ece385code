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

	logic [1407:0] KeySchedule;
	logic [127:0] state;
	logic [127:0] key;
	logic [127:0] addroundkey_out;
	logic [127:0] invshiftrows_in;
	logic [127:0] invshiftrows_out;
	logic [127:0] mixcolumns_in;
	logic [127:0] mixcolumns_out;

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
		ADDRK



		
		
	} AES_STATE, AES_NEXT_STATE;
	
	
	
	
	always_ff @(posedge CLK)
	begin
		if (RESET) begin
			AES_STATE <= WAIT;
			Loop_counter <=4'b0;
		end
		
		else begin
			AES_STATE <= AES_NEXT_STATE;
			Loop_counter <= Loop_counter_next;
		end
	end
	
	always_comb
	begin
	
	//Transition relation
	
	end
	
	always_comb
	begin
		
		unique case (AES_STATE)
			
			WAIT:
				begin
					AES_DONE = 0;
				end
				
			DONE:
				begin
					AES_DONE = 1;
				end
			
			KEY_EXPANSION:
				begin
					
					AES_DONE = 0;
				end
				
			INITIAL_ROUND:
				begin

					AES_DONE = 0;
				end
				
		endcase
		
	end
	
	
	//KeyExpansion
	KeyExpansion keyexpansion(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(KeySchedule));

	// AddRoundKey
	AddRoundKey addroundkey(.state(state), .roundKey(key), .out(addroundkey_out));
	
	//InvShiftRows
	InvShiftRows invshiftrows(.data_in(invshiftrows_in), .data_out(invshiftrows_out));

	// InvMixColumns
	InvMixColumns invmixcolumns(.in(mixcolumns_in),.out(mixcolumns_out));
endmodule
