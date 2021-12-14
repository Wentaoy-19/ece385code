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
	output logic [127:0] AES_MSG_DEC,
	output logic [127:0] next_state_out
);

	logic [1407:0] KeySchedule;
	logic [127:0] state;
	logic [127:0] next_state;
	logic [127:0] key;
	logic [127:0] addroundkey_out;
	logic [127:0] invshiftrows_out;
	logic [31:0] mixcolumns_in;
	logic [31:0] mixcolumns_out;
	logic [127:0] Sub_Out;

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
	
	assign next_state_out = next_state;
	
	always_ff @(posedge CLK)
	begin
		if (RESET) begin
			AES_STATE <= WAIT;
			loop_counter <=4'b0;
			state <= 128'b0;

		end
		
		else begin
			state <= next_state;
			AES_STATE <= AES_NEXT_STATE;
			loop_counter = loop_counter_next;
		end
	end
	
	
	//Transition Relations
	always_comb 
	begin 
	
		AES_NEXT_STATE = AES_STATE; 
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
			//AES_NEXT_STATE = LOOP_INVSHIFTROW;
			AES_NEXT_STATE = DONE;
		
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
				begin
				loop_counter_next = loop_counter + 4'b1;
				AES_NEXT_STATE = LOOP_INVSHIFTROW;
				end
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
	
	//State Contents
	always_comb
	begin
	
		next_state = state;
		AES_DONE = 1'b0;
		
		AES_MSG_DEC = 128'b0;
//		AES_MSG_DEC = state;
		
		mixcolumns_in = 32'b0;
		key = 128'b0;
		
		unique case (AES_STATE)
			
			WAIT:
				begin
					AES_DONE = 0;
				end
				
			DONE:
				begin
					AES_MSG_DEC = state;
					AES_DONE = 1'b1;
				end
			
			KEY_EXPANSION:
				begin
					next_state = AES_MSG_ENC;					
					AES_DONE = 1'b0;
				end
				
			INITIAL_ROUND:
				begin
					key = KeySchedule[127:0];
					next_state = addroundkey_out;
					AES_DONE = 1'b0;
				end
			
			LOOP_INVSUB:
				begin
					next_state = Sub_Out;
					AES_DONE = 0;
				end
				
			LOOP_INVSHIFTROW:
				begin
					next_state = invshiftrows_out;
					AES_DONE = 0;
				end
			
			LOOP_INVMIXCOL1:
				begin
					mixcolumns_in = state[31:0];
					next_state[31:0] = mixcolumns_out;
					AES_DONE = 0;
				end
				
			LOOP_INVMIXCOL2:
				begin
					mixcolumns_in = state[63:32];
					next_state[63:32] = mixcolumns_out;
					AES_DONE = 0;
				end
		
			LOOP_INVMIXCOL3:
				begin
					mixcolumns_in = state[95:64];
					next_state[95:64] = mixcolumns_out;
					AES_DONE = 0;
				end
				
			LOOP_INVMIXCOL4:
				begin
					mixcolumns_in = state[127:96];
					next_state[127:96] = mixcolumns_out;
					AES_DONE = 0;
				end	
				
			LOOP_ADDRK:
				begin
					case (loop_counter)
						4'd0:key = KeySchedule[255:128];
						4'd1:key = KeySchedule[383:256];
						4'd2:key = KeySchedule[511:384];
						4'd3:key = KeySchedule[639:512];
						4'd4:key = KeySchedule[767:640];
						4'd5:key = KeySchedule[895:768];
						4'd6:key = KeySchedule[1023:896];
						4'd7:key = KeySchedule[1151:1024];
						4'd8:key = KeySchedule[1279:1152];
						default: 
							key = 128'b0;
					endcase
					next_state = addroundkey_out;
					AES_DONE = 0;
				end

			INVSUB:
				begin
					next_state = Sub_Out;
					AES_DONE = 0;
				end
				
			INVSHIFTROW:
				begin
					next_state = invshiftrows_out;
					AES_DONE = 0;
				end
				
			ADDRK:
				begin
					key = KeySchedule[1407:1280];
					next_state = addroundkey_out;
					AES_DONE = 0;
				end
		endcase
		
	end
	
	
	//KeyExpansion
	KeyExpansion keyexpansion(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(KeySchedule));

	// AddRoundKey
	AddRoundKey addroundkey(.state(state), .roundKey(key), .out(addroundkey_out));
	
	//InvShiftRows
	InvShiftRows invshiftrows(.data_in(state), .data_out(invshiftrows_out));

	// InvMixColumns
	InvMixColumns invmixcolumns(.in(mixcolumns_in),.out(mixcolumns_out));
	
	// InvSubBytes  
	InvSubBytes sub0(.clk(CLK), .in(state[7:0]), .out(Sub_Out[7:0]));  
	InvSubBytes sub1(.clk(CLK), .in(state[15:8]), .out(Sub_Out[15:8]));  
	InvSubBytes sub2(.clk(CLK), .in(state[23:16]), .out(Sub_Out[23:16]));  
	InvSubBytes sub3(.clk(CLK), .in(state[31:24]), .out(Sub_Out[31:24]));  
	InvSubBytes sub4(.clk(CLK), .in(state[39:32]), .out(Sub_Out[39:32]));  
	InvSubBytes sub5(.clk(CLK), .in(state[47:40]), .out(Sub_Out[47:40]));  
	InvSubBytes sub6(.clk(CLK), .in(state[55:48]), .out(Sub_Out[55:48]));  
	InvSubBytes sub7(.clk(CLK), .in(state[63:56]), .out(Sub_Out[63:56]));  
	InvSubBytes sub8(.clk(CLK), .in(state[71:64]), .out(Sub_Out[71:64]));  
	InvSubBytes sub9(.clk(CLK), .in(state[79:72]), .out(Sub_Out[79:72]));  
	InvSubBytes sub10(.clk(CLK), .in(state[87:80]), .out(Sub_Out[87:80]));  
	InvSubBytes sub11(.clk(CLK), .in(state[95:88]), .out(Sub_Out[95:88]));  
	InvSubBytes sub12(.clk(CLK), .in(state[103:96]), .out(Sub_Out[103:96]));  
	InvSubBytes sub13(.clk(CLK), .in(state[111:104]), .out(Sub_Out[111:104]));  
	InvSubBytes sub14(.clk(CLK), .in(state[119:112]), .out(Sub_Out[119:112]));  
	InvSubBytes sub15(.clk(CLK), .in(state[127:120]), .out(Sub_Out[127:120]));
	
endmodule
