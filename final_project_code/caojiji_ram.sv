/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

 
module caojiji
(input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  
									  
					input [7:0]   frame_num,
					input [7:0]   character1_state,
					input logic move_l,move_r,character1_move_r, character1_move_l,
					
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_character, 
					output logic [7:0] data_Out
); 
	parameter [18:0] SCREEN_WIDTH =  19'd480;
   parameter [18:0] SCREEN_LENGTH = 19'd640;
	parameter [18:0] FORWARD_WIDTH = 19'd51;
	parameter [18:0] FORWARD_HEIGHT = 19'd105;
	parameter [18:0] BACKWARD_WIDTH = 19'd51;
	parameter [18:0] BACKWARD_HEIGHT = 19'd108;
	parameter [18:0] ATTACK_WIDTH = 19'd80;
	parameter [18:0] ATTACK_HEIGHT = 19'd98;
	parameter [18:0] STAND_WIDTH = 19'd42;
	parameter [18:0] STAND_HEIGHT = 19'd104;
	parameter [18:0] HURT_HEIGHT = 19'd95; 
	parameter [18:0] HURT_WIDTH = 19'd64; 
	parameter [18:0] DEFEND_HEIGHT = 19'd94;
	parameter [18:0] DEFEND_WIDTH = 19'd64;
	

	logic [18:0] read_address,read_address_forward,read_address_backward,read_address_stand,read_address_attack,read_address_hurt,read_address_defend;
	logic [18:0] character_x,character_y,character_x_in, character_y_in; 	
	logic [18:0] image_width, image_height;	
	logic [7:0] data_out_forward, data_out_backward,data_out_attack,data_out_stand,data_out_hurt,data_out_defend;
	
	
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            character_x <= 19'd320;
            character_y <= 19'd240;
        end
        else
        begin
				character_x <= character_x_in;
				character_y <= character_y_in;
        end
    end
	
	enum logic [7:0] {state_stand,state_attack, state_movel, state_mover} state_in;
	
	assign read_address_forward = frame_num*FORWARD_WIDTH*FORWARD_HEIGHT+ (DrawX - character_x) + (DrawY - character_y)*FORWARD_WIDTH;  
	assign read_address_backward = frame_num*BACKWARD_WIDTH*BACKWARD_HEIGHT+ (DrawX - character_x) + (DrawY - character_y)*BACKWARD_WIDTH;  
	assign read_address_attack = frame_num*ATTACK_WIDTH*ATTACK_HEIGHT+ (DrawX - character_x) + (DrawY - character_y)*ATTACK_WIDTH;  
	assign read_address_stand = frame_num*STAND_WIDTH*STAND_HEIGHT + (DrawX - character_x) + (DrawY - character_y)*STAND_WIDTH;
	assign read_address_defend = frame_num*DEFEND_WIDTH*DEFEND_HEIGHT + (DrawX - character_x) + (DrawY - character_y)*DEFEND_WIDTH;
	assign read_address_hurt = frame_num*HURT_WIDTH*HURT_HEIGHT + (DrawX - character_x) + (DrawY - character_y)*HURT_WIDTH;
//	assign read_address = frame_num*ATTACK_WIDTH*ATTACK_HEIGHT+ (DrawX - character_x) + (DrawY - character_y)*ATTACK_WIDTH;  
//	assign read_address = frame_num*BACKWARD_WIDTH*BACKWARD_HEIGHT+ (DrawX - character_x) + (DrawY - character_y)*BACKWARD_WIDTH;  


	
	
	andy_forward_RAM andy_forward_RAM(.read_address(read_address_forward),.Clk(Clk), .data_Out(data_out_forward) );
	andy_backward_RAM andy_backward_RAM(.read_address(read_address_backward),.Clk(Clk), .data_Out(data_out_backward) );
	andy_stand_RAM andy_stand_RAM(.read_address(read_address_stand),.Clk(Clk), .data_Out(data_out_stand) );
	andy_attack_RAM andy_attack_RAM(.read_address(read_address_attack),.Clk(Clk), .data_Out(data_out_attack) );
	andy_hurt_RAM andy_hurt_RAM(.read_address(read_address_hurt),.Clk(Clk), .data_Out(data_out_hurt));
	andy_defend_RAM andy_defend_RAM(.read_address(read_address_defend),.Clk(Clk), .data_Out(data_out_defend));
	
	always_comb 
	begin 
		if(character1_state == state_stand)
		begin
			image_width = STAND_WIDTH;
			image_height = STAND_HEIGHT;
			data_Out = data_out_stand;
		end
		else if(character1_state == state_attack)
		begin
			image_width = ATTACK_WIDTH;
			image_height = ATTACK_HEIGHT;
			data_Out = data_out_attack;
		end	
		else if(character1_state == state_mover)
		begin
			image_width = FORWARD_WIDTH;
			image_height = FORWARD_HEIGHT;
			data_Out = data_out_forward;
		end	
		else if(character1_state == state_movel )
		begin
			image_width = BACKWARD_WIDTH;
			image_height = BACKWARD_HEIGHT;
			data_Out = data_out_backward;
		end	
		else
		begin
			image_width = STAND_WIDTH;
			image_height = STAND_HEIGHT;
			data_Out = data_out_stand;
		end	
	end
	
	always_comb 
	begin
		character_x_in = character_x;
		character_y_in = character_y;
		if(move_r)
		begin
			character_x_in = character_x + 19'b1;
		end
		if(move_l)
		begin
			character_x_in = character_x - 19'b1;
		end
		
		
		if(character_x_in + FORWARD_WIDTH >= 19'd640)
		begin
			character_x_in = 19'd640-FORWARD_WIDTH;
		end
		if(character_x_in <= 19'd4)
		begin
			character_x_in = 19'd4;
		end
	end




	always_comb begin
		is_character = 1'b0;
		if (DrawX >= character_x && DrawX<character_x + image_width && DrawY >= character_y && DrawY<character_y + image_height )
			is_character = 1'b1;
	end
 
 endmodule
 

 
module  andy_forward_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

logic [7:0] mem [0:26774];

initial
begin
	 $readmemh("images/Andy_new/andy_forward.txt", mem);
end

always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  andy_backward_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

logic [7:0] mem [0:27539];

initial
begin
	 $readmemh("images/Andy_new/andy_backward.txt", mem);
end

always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  andy_attack_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:70559];

initial
begin
	 $readmemh("images/Andy_new/andy_attack.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  andy_stand_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:34943];

initial
begin
	 $readmemh("images/Andy_new/andy_stand.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule


module  andy_hurt_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:24319];

initial
begin
	 $readmemh("images/Andy_new/andy_hurt.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  andy_defend_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:6015];

initial
begin
	 $readmemh("images/Andy_new/andy_defense_0.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule


