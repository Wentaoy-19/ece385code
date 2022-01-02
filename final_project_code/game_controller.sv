module game_controller(
	 input Clk,Reset,
    input game_start, game_over, game_restart,
    output logic exist_character1, exist_character2, exist_background,exist_foreground,exist_hp,exist_ko,game_state
);
	enum logic [7:0] {state_start,state_game, state_gameover} state_in, state;
    logic exist_character1_in, exist_character2_in, exist_background_in, exist_foreground_in,exist_hp_in,exist_ko_in;

    assign game_state = state;

	always_ff @ (posedge Clk)
    begin
		if(Reset)
		begin
				state <= state_start;
				exist_character1 <= 1'b0;
            exist_character2 <= 1'b0; 
            exist_background <= 1'b0; 
            exist_foreground <= 1'b1;
				exist_hp <= 1'b0;
                exist_ko <= 1'b0;

		end
		else
		begin
            state<= state_in;
            exist_character1 <= exist_character1_in;
            exist_character2 <= exist_character2_in; 
            exist_background <= exist_background_in; 
            exist_foreground <= exist_foreground_in;
				exist_hp <= exist_hp_in;
                exist_ko <= exist_ko_in;
		end
	end

    always_comb 
    begin
        state_in = state;
        unique case(state)
            state_start:
            begin
               if(game_start)
               begin
                   state_in = state_game;
               end 
            end

            state_game:
            begin
                if(game_over)
                begin
                    state_in = state_gameover;
                end
            end

            state_gameover:
            begin
                if(game_restart)
                begin
                   state_in = state_game; 
                end
            end
        endcase 
    end


    always_comb 
    begin 
        exist_background_in = exist_background;
        exist_foreground_in = exist_foreground;
        exist_character1_in = exist_character1;
        exist_character2_in = exist_character2;
		  exist_hp_in = exist_hp;
          exist_ko_in = exist_ko;

        if(state == state_start)
        begin
            exist_background_in = 1'b0;
            exist_character1_in = 1'b0;
            exist_character2_in = 1'b0;
            exist_foreground_in = 1'b1;
				exist_hp_in = 1'b0;
                exist_ko_in = 1'b0;
        end

        else if(state == state_game)
        begin
            exist_background_in = 1'b1;
            exist_character1_in = 1'b1;
            exist_character2_in = 1'b1;
            exist_foreground_in = 1'b0;
				exist_hp_in = 1'b1;
                exist_ko_in = 1'b0;
        end

        else if(state == state_gameover)
        begin 
            exist_background_in = 1'b1;
            exist_character1_in = 1'b1;
            exist_character2_in = 1'b1;
            exist_foreground_in = 1'b0; 
			   exist_hp_in = 1'b1;
            exist_ko_in = 1'b1;
        end
        
    end

endmodule