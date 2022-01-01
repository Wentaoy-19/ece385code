module iori_FSM(input Clk,                
                      Reset,              
                      frame_clk, 
							 character2_attack,
							 character2_move_r,
							 character2_move_l,
							 character2_hurt,
							 character2_defense,
					 output  [7:0] state_out, 
					 output	[7:0] frame_num,
					 output logic move_l2,move_r2,stand2,attack
);

	logic [7:0] frame_num_in;
	logic [7:0] delay_in, delay;
	logic move_r_in, move_l_in,stand_in,attack_in;	
	logic frame_clk_delayed, frame_clk_edge; 
	logic [7:0] frame_num_max,frame_num_max_in;
	parameter [7:0] delay_move_r = 8'd10;	
	parameter [7:0] delay_move_l = 8'd10;
	parameter [7:0] delay_attack = 8'd3;
	parameter [7:0] delay_stand = 8'd10;
	parameter [7:0] delay_defense = 8'd10;
	parameter [7:0] delay_hurt = 8'd10;
	parameter [7:0] frame_num_move_r = 8'd8; 
	parameter [7:0] frame_num_move_l = 8'd9; 	
	parameter [7:0] frame_num_attack = 8'd5;
	parameter [7:0] frame_num_stand = 8'd8;
	parameter [7:0] frame_num_defense = 8'd0;
	parameter [7:0] frame_num_hurt = 8'd4;
	
	enum logic [7:0] {state_stand,state_attack, state_movel, state_mover, state_defense, state_hurt} state_in, state;
	assign state_out = state;
					 
	 always_ff @ (posedge Clk)
    begin
		if(Reset)
		begin
			state <= state_stand;
			delay <= 8'd0;
			frame_num <= 8'd0;
			frame_num_max <= frame_num_stand;
			move_r2 <= 1'b0;
			move_l2 <= 1'b0;
			stand2 <= 1'b0;
			attack <= 1'b0;
		end
		else
		begin
			state <= state_in;
			delay <= delay_in;
			frame_num <= frame_num_in;
			frame_num_max <= frame_num_max_in;
			move_r2 <= move_r_in;
			move_l2 <= move_l_in;
			stand2 <= stand_in;
			attack <= attack_in;
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
	move_l_in = 1'b0;
	move_r_in = 1'b0;
	stand_in = 1'b0;
	attack_in = 1'b0;
	
	if(frame_clk_edge)
	begin
	
	unique case(state)
	
	state_attack:
	begin
		attack_in = 1'b1;
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
				frame_num_in = frame_num + 8'd1;
		end
		else
		begin
			delay_in = delay + 8'd1;
		end
		
	end
	
	
	
	state_defense:
	begin
		if(delay>=delay_defense)
		begin
			delay_in = 8'd0;
			if(frame_num>= frame_num_defense)
			begin
				frame_num_in = 8'd0;
				state_in = state_stand;
				delay_in = 8'd0;
			end
			else
				frame_num_in = frame_num + 8'd1;
		end
		else
		begin
			delay_in = delay + 8'd1;
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
				frame_num_in = frame_num + 8'd1;
		end
		else
		begin
			delay_in = delay + 8'd1;
		end
		
	end

	

	state_mover: 
	begin
		move_r_in = 1'b1;
		if(character2_move_r)
		begin
			if(delay>=delay_move_r)
			begin
				delay_in = 8'd0;
				if(frame_num >= frame_num_move_r)
					frame_num_in = 8'd0;
				else
					frame_num_in = frame_num + 8'd1;
			end
			else
			begin
				delay_in = delay + 8'd1;
			end
		end
		else if(character2_attack)
		begin
			state_in = state_attack;
			delay_in = 8'd0;
			frame_num_in = 8'd0;	
		end
		else if(character2_move_l)
		begin
			state_in = state_movel;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		else if(character2_defense)
		begin
			state_in = state_defense;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		else if(character2_hurt)
		begin
			state_in = state_hurt;
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
		move_l_in = 1'b1;
		if(character2_move_l)
		begin
			if(delay>=delay_move_l)
			begin
				delay_in = 8'd0;
				if(frame_num >= frame_num_move_l)
					frame_num_in = 8'd0;
				else
					frame_num_in = frame_num + 8'd1;
			end
			else
			begin
				delay_in = delay + 8'd1;
			end
		end
		else if(character2_attack)
		begin
			state_in = state_attack;
			delay_in = 8'd0;
			frame_num_in = 8'd0;	
		end
		else if(character2_move_r)
		begin
			state_in = state_mover;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		else if(character2_defense)
		begin
			state_in = state_defense;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		else if(character2_hurt)
		begin
			state_in = state_hurt;
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
		stand_in = 1'b1;
		if(character2_attack)
		begin
			state_in = state_attack;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		else if(character2_move_r)
		begin
			state_in = state_mover;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		else if(character2_move_l)
		begin
			state_in = state_movel;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		else if(character2_defense)
		begin
			state_in = state_defense;
			delay_in = 8'd0;
			frame_num_in = 8'd0;
		end
		else if(character2_hurt)
		begin
			state_in = state_hurt;
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
	
	
	endcase
	
	
	end
	
	end
	 
endmodule



 
