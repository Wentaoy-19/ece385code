module caojiji_FSM(input     Clk,                
                             Reset,              
                             frame_clk, 
									  character1_attack,
									  character1_move_r,
									  character1_move_l,
									  character1_hurt,
									  character1_defend,

					 output  [7:0] state_out, 
					 output	[7:0] frame_num,
					 output  logic move_l1,move_r1
					 );

	logic [7:0] frame_num_in;
	logic move_r1_in, move_l1_in;
	logic [7:0] delay_in, delay; 
	logic frame_clk_delayed, frame_clk_edge; 
	logic [7:0] frame_num_max,frame_num_max_in;
	parameter [7:0] delay_move_r1 = 8'd10;	
	parameter [7:0] delay_move_l1 = 8'd10;
	parameter [7:0] delay_attack = 8'd3;
	parameter [7:0] delay_stand = 8'd10;
	parameter [7:0] delay_hurt = 8'd10; 
	parameter [7:0] delay_defend = 8'd3;
	parameter [7:0] frame_num_move_r1 = 8'd3; 
	parameter [7:0] frame_num_move_l1 = 8'd4; 	
	parameter [7:0] frame_num_attack = 8'd8;
	parameter [7:0] frame_num_stand = 8'd7;
	parameter [7:0] frame_num_hurt = 8'd3; 
	parameter [7:0] frame_num_defend = 8'd0;
	
	enum logic [7:0] {state_stand,state_attack, state_movel, state_mover,state_hurt,state_defend} state_in, state;
	assign state_out = state;
					 
	always_ff @ (posedge Clk)
    begin
		if(Reset)
		begin
			state <= state_stand;
			delay <= 8'd0;
			frame_num <= 8'd0;
			frame_num_max <= frame_num_stand;
			move_r1 <= 1'b0;
			move_l1 <= 1'b0;
		end
		else
		begin
			state <= state_in;
			delay <= delay_in;
			frame_num <= frame_num_in;
			frame_num_max <= frame_num_max_in;
			move_r1 <= move_r1_in;
			move_l1 <= move_l1_in;
		end
	 end					 

	 
	 always_ff @(posedge Clk)
	 begin 
		frame_clk_delayed <= frame_clk; 
		frame_clk_edge <= frame_clk && (frame_clk_delayed == 1'b0);
	 end
	 
	 
//	 
//	 always_comb 
//	 begin 
//	 
//	 state_in = state;
//	 delay_in = delay; 
//	 state = state_in;
//	 frame_num_in = frame_num;
//	 
//	 if(frame_clk_edge) begin
//
//		if(delay >= delay_forward) 
//		begin
//			delay_in = 8'd0;
//			
//			if(frame_num >= frame_num_backward)
//				frame_num_in = 8'd0;
//			else
//				frame_num_in = frame_num+8'd1;
//		end
//		
//		else
//		begin
//			delay_in = delay + 8'd1;
//		end
//
//			
//			
//	 end
//	 
//	 end

	always_comb 
	begin 
	
	state_in = state; 
	delay_in = delay; 
	frame_num_in = frame_num;
	frame_num_max_in = frame_num_max;
	move_l1_in = 1'b0;
	move_r1_in = 1'b0;
	
	if(frame_clk_edge)
	begin
	
	unique case(state)
	
	state_attack:
	begin
		if(delay>=delay_attack)
		begin
			delay_in = 8'd0;
			if(frame_num>= frame_num_attack)
			begin
				frame_num_in = 8'd0;
				state_in = state_stand;
				delay_in = 8'd0;
			end
			else
			begin
				frame_num_in = frame_num + 8'd1;
			end
		end
		else
		begin
			delay_in = delay + 8'd1;
		end
		
	end
	
	
//	state_attack: 
//	begin
//		if(character1_attack)
//		begin
//			if(delay>=delay_attack)
//			begin
//				delay_in = 8'd0;
//				if(frame_num >= frame_num_attack)
//					frame_num_in = 8'd0;
//				else
//					frame_num_in = frame_num + 8'd1;
//			end
//			else
//			begin
//				delay_in = delay + 8'd1;
//			end
//		end
//		else if(character1_move_r)
//		begin
//			state_in = state_mover;
//			delay_in = 8'd0;
//			frame_num_in = 8'd0;	
//		end
//		else if(character1_move_l)
//		begin
//			state_in = state_movel;
//			delay_in = 8'd0;
//			frame_num_in = 8'd0;
//		end
//		else
//		begin
//			state_in = state_stand;
//			delay_in = 8'd0;
//			frame_num_in = 8'd0;
//		end
//	end

	

	state_mover: 
	begin
		if(character1_hurt)
		begin
			frame_num_in = 8'd0;
			delay_in = 8'd0;
			state_in = state_hurt;
		end
		

		
		else if(character1_move_r)
		begin
			move_r1_in = 1'b1;
			if(delay>=delay_move_r1)
			begin
				delay_in = 8'd0;
				if(frame_num >= frame_num_move_r1)
				begin
					frame_num_in = 8'd0;
				end
				else
				begin
					frame_num_in = frame_num + 8'd1;
				end
			end
			else
			begin
				delay_in = delay + 8'd1;
			end
		end
		else if(character1_attack)
		begin
			state_in = state_attack;
			delay_in = 8'd0;
			frame_num_in = 8'd0;	
		end
		else if(character1_move_l)
		begin
			state_in = state_movel;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		else
		begin
			state_in = state_stand;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
	end
	
	state_movel: 
	begin
		if(character1_hurt)
		begin
			frame_num_in = 8'd0;
			delay_in = 8'd0;
			state_in = state_hurt;
		end
		

		if(character1_move_l)
		begin
			move_l1_in = 1'b1;
			if(delay>=delay_move_l1)
			begin
				delay_in = 8'd0;
				if(frame_num >= frame_num_move_l1)
					frame_num_in = 8'd0;
				else
				begin
					frame_num_in = frame_num + 8'd1;
				end
			end
			else
			begin
				delay_in = delay + 8'd1;
			end
		end
		else if(character1_attack)
		begin
			state_in = state_attack;
			delay_in = 8'd0;
			frame_num_in = 8'd0;	
		end
		else if(character1_move_r)
		begin
			state_in = state_mover;
			delay_in = 8'd0;
			frame_num_in = 8'd0;

		end
		else
		begin
			state_in = state_stand;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
	end
	
	
	state_stand:
	begin
		if(character1_hurt)
		begin
			state_in = state_hurt;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		
		else if(character1_attack)
		begin
			state_in = state_attack;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		else if(character1_defend)
		begin
			state_in = state_defend;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		
		else if(character1_move_r)
		begin
			state_in = state_mover;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		else if(character1_move_l)
		begin
			state_in = state_movel;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		
		else
		begin
			if(delay>=delay_stand)
			begin
				delay_in = 8'd0;
				if(frame_num >= frame_num_stand)
					frame_num_in = 8'd0;
				else
					frame_num_in = frame_num + 8'd1;
			end
			else
			begin
				delay_in = delay + 8'd1;
			end
		end
	end
	
	state_hurt:
	begin
		if(delay>=delay_hurt)
		begin
			delay_in = 8'd0;
			if(frame_num>= frame_num_hurt)
			begin
				frame_num_in = 8'd0;
				state_in = state_stand;
				delay_in = 8'd0;
			end
			else
			begin
				frame_num_in = frame_num + 8'd1;
			end
		end
		else
		begin
			delay_in = delay + 8'd1;
		end
	end
	
	state_defend:
	begin
		if(delay>=delay_defend)
		begin
			delay_in = 8'd0;
			if(frame_num>= frame_num_defend)
			begin
				frame_num_in = 8'd0;
				delay_in = 8'd0;
				if(character1_defend)
				begin
					state_in = state_defend;
				end
				else
				begin
					state_in = state_stand;
				end
			end
			else
			begin
				frame_num_in = frame_num + 8'd1;
			end
		end
		else
		begin
			delay_in = delay + 8'd1;
		end
		
	end
	
	
	endcase
	
	
	end
	
	end
	 
endmodule



 
