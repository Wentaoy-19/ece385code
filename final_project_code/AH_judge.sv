module AH_judge(
    input logic attack1,
                attack2,
                defend1,
                defend2,
	 input logic [7:0] character1_state, character2_state,
    input  logic [18:0] character1_x,
                        character2_x,

    output logic character1_hurt, character2_hurt, character1_attack_confirm, character2_attack_confirm
);

    parameter [18:0] attack_distance = 19'd70; 
	enum logic [7:0] {state_stand,state_attack, state_movel, state_mover, state_defense, state_hurt} state_in;
	

    always_comb begin
		  character1_attack_confirm = attack1;
		  character2_attack_confirm = attack2;
	 
	 
		  character1_hurt = 1'b0;
		  character2_hurt = 1'b0;
        if(character2_x - character1_x <= attack_distance)
        begin
            if( attack1 && ~defend2 && character1_state!= state_attack && character1_state!= state_defense)
            begin
                character2_hurt = 1'b1;
            end
            else if(attack2 && ~defend1 && character2_state != state_attack && character2_state!= state_defense)
            begin
                character1_hurt = 1'b1;
            end
        end
		  else 
		  begin
				
		  end
        
    end

endmodule 
