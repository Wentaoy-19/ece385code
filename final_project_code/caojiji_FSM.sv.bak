module caojiji_FSM(input     Clk,                
                             Reset,              
                             frame_clk, 
					 input [15:0] keycode, 
					 output  [7:0] state_out, 
					 output	[7:0] frame_num);

	logic [7:0] state_in; 
	logic [7:0] frame_num_in;
	logic [7:0] delay_in, delay; 
	logic frame_clk_delayed, frame_clk_edge; 
					 
	logic [7:0] state;			 
					 
					 
					 
					 
	 always_ff @ (posedge Clk)
    begin
		state <= state_in;
		delay <= delay_in;
		frame_num <= frame_num_in;
	 end					 

	 
	 always_ff @(posedge Clk)
	 begin 
		frame_clk_delayed <= frame_clk; 
		frame_clk_edge <= frame_clk && (frame_clk_delayed == 1'b0);
	 end
	 
	 
	 
	 always_comb 
	 begin 
	 
	 state_out = state;
	 state_in = state;
	 delay_in = delay; 
	 state = state_in;
	 frame_num_in = frame_num;

	 
	 

	 if(frame_clk_edge) begin
	 
//	 case(keycode)
//		8'h0004:
//			begin
//				
//			end
//	 endcase 
	 
	 

		if(delay >= 8'd10) begin
		
			delay_in = 8'd0;
			
			if(frame_num >= 8'd4)
				frame_num_in = 8'd0;
			else
				frame_num_in = frame_num+8'd1;
		end
		
		else
		begin
			delay_in = delay + 8'd1;
		end

			
			
	 end
	 
	 end
	 
endmodule



 
