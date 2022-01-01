module AH_judge(
    input logic attack1,
                attack2,
                defend1,
                defend2,
    input  logic [18:0] character1_x,
                        character2_x,

    output logic character1_hurt, character2_hurt  
);

    parameter [18:0] attack_distance = 19'd40; 
    
    logic within_distance;

    assign within_distance = character2_x - character1_x <= attack_distance ? 1'b1 : 1'b0; 

    always_comb begin
		  character1_hurt = 1'b0;
		  character2_hurt = 1'b0;
        if(within_distance)
        begin
            if( attack1 && ~defend2)
            begin
                character2_hurt = 1'b1;
            end
            else if(attack2 && ~defend1)
            begin
                character1_hurt = 1'b1;
            end
        end
        
    end

endmodule 
