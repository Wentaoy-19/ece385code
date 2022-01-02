module game_controller(
    input game_start, game_over, game_restart,
    input logic reset,
    output logic is_character1, is_character2, is_background,is_foreground,game_state
);
	enum logic [7:0] {state_start,state_game, state_gameover} state_in, state;
    logic is_character1_in, is_character2_in, is_background_in, is_foreground_in;

    assign game_state = state;

	always_ff @ (posedge Clk)
    begin
		if(Reset)
		begin
            state <= state_start; 
            is_character1 <= 1'b0;
            is_character2 <= 1'b0; 
            is_background <= 1'b0; 
            is_foreground <= 1'b1;
		end
		else
		begin
            state<= state_in;
            is_character1 <= is_character1_in;
            is_character2 <= is_character2_in; 
            is_background <= is_background_in; 
            is_foreground <= is_foreground_in;
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
                   state_in = state_game
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
        is_background_in = is_background;
        is_foreground_in = is_foreground;
        is_character1_in = is_character1;
        is_character2_in = is_character2;

        if(state == state_start)
        begin
            is_background_in = 1'b0;
            is_character1_in = 1'b0;
            is_character2_in = 1'b0;
            is_foreground_in = 1'b1;
        end

        else if(state == state_game)
        begin
            is_background_in = 1'b1;
            is_character1_in = 1'b1;
            is_character2_in = 1'b1;
            is_foreground_in = 1'b0;
        end

        else if(state == state_gameover)
        begin 
            is_background_in = 1'b1;
            is_character1_in = 1'b1;
            is_character2_in = 1'b1;
            is_foreground_in = 1'b0;           
        end
        
    end

endmodule