/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

 
module Iori
(input         Clk,// 50 MHz clock
               Reset,              // Active-high reset signal
               frame_clk,          // The clock indicating a new frame (~60Hz)
									  
									  
					input [7:0]   frame_num,
					input [7:0]   character2_state,
					
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_character, 
					output logic [7:0] data_Out
); 
	parameter [18:0] SCREEN_WIDTH =  19'd480;
   parameter [18:0] SCREEN_LENGTH = 19'd640;
	parameter [18:0] FORWARD_WIDTH = 19'd68;
	parameter [18:0] FORWARD_HEIGHT = 19'd104;
	parameter [18:0] BACKWARD_WIDTH = 19'd70;
	parameter [18:0] BACKWARD_HEIGHT = 19'd107;
	parameter [18:0] ATTACK_WIDTH = 19'd101;
	parameter [18:0] ATTACK_HEIGHT = 19'd100;
	parameter [18:0] STAND_WIDTH = 19'd74;
	parameter [18:0] STAND_HEIGHT = 19'd102;
	parameter [18:0] DEFENSE_WIDTH = 19'd88;
	parameter [18:0] DEFENSE_HEIGHT = 19'd102;
	parameter [18:0] HURT_WIDTH = 19'd85;
	parameter [18:0] HURT_HEIGHT = 19'd95;

	logic [18:0] read_address,read_address_forward,read_address_backward,read_address_stand,read_address_attack,read_address_defense,read_address_hurt;
	logic [18:0] character_x,character_y,character_x_in, character_y_in; 	
	logic [18:0] image_width, image_height;	
	logic [7:0] data_out_forward, data_out_backward,data_out_attack,data_out_stand,data_out_defense,data_out_hurt;
	
	assign character_x = 19'd400;
	assign character_y = 19'd200; 
	
	enum logic [7:0] {state_stand,state_attack, state_movel, state_mover, state_defense, state_hurt} state_in;
	
	assign read_address_forward = frame_num*FORWARD_WIDTH*FORWARD_HEIGHT+ (DrawX - character_x) + (DrawY - character_y)*FORWARD_WIDTH;  
	assign read_address_backward = frame_num*BACKWARD_WIDTH*BACKWARD_HEIGHT+ (DrawX - character_x) + (DrawY - character_y)*BACKWARD_WIDTH;  
	assign read_address_attack = frame_num*ATTACK_WIDTH*ATTACK_HEIGHT+ (DrawX - character_x) + (DrawY - character_y)*ATTACK_WIDTH;  
	assign read_address_stand = frame_num*STAND_WIDTH*STAND_HEIGHT + (DrawX - character_x) + (DrawY - character_y)*STAND_WIDTH;
	assign read_address_defense = frame_num*DEFENSE_WIDTH*DEFENSE_HEIGHT + (DrawX - character_x) + (DrawY - character_y)*DEFENSE_WIDTH;
	assign read_address_hurt = frame_num*HURT_WIDTH*HURT_HEIGHT + (DrawX - character_x) + (DrawY - character_y)*HURT_WIDTH;


	
	
	forward_RAM forward_RAM(.read_address(read_address_forward),.Clk(Clk), .data_Out(data_out_forward) );
	backward_RAM backward_RAM(.read_address(read_address_backward),.Clk(Clk), .data_Out(data_out_backward) );
	stand_RAM stand_RAM(.read_address(read_address_stand),.Clk(Clk), .data_Out(data_out_stand) );
	attack_RAM attack_RAM(.read_address(read_address_attack),.Clk(Clk), .data_Out(data_out_attack) );
	defense_RAM defense_RAM(.read_address(read_address_attack),.Clk(Clk), .data_Out(data_out_attack) );
	hurt_RAM hurt_RAM(.read_address(read_address_attack),.Clk(Clk), .data_Out(data_out_attack) );
	
	always_comb 
	begin 
		
		if(character2_state == state_stand)
		begin
			image_width = STAND_WIDTH;
			image_height = STAND_HEIGHT;
			data_Out = data_out_stand;
		end
		else if(character2_state == state_attack)
		begin
			image_width = ATTACK_WIDTH;
			image_height = ATTACK_HEIGHT;
			data_Out = data_out_attack;
		end	
		else if(character2_state == state_mover)
		begin
			image_width = BACKWARD_WIDTH;
			image_height = BACKWARD_HEIGHT;
			data_Out = data_out_backward;
		end	
		else if(character2_state == state_movel)
		begin
			image_width = FORWARD_WIDTH;
			image_height = FORWARD_HEIGHT;
			data_Out = data_out_forward;
		end	
		else if(character2_state == state_defense)
		begin
			image_width = DEFENSE_WIDTH;
			image_height = DEFENSE_HEIGHT;
			data_Out = data_out_defense;
		end
		else if(character2_state == state_hurt)
		begin
			image_width = HURT_WIDTH;
			image_height = HURT_HEIGHT;
			data_Out = data_out_hurt;
		end
		else
		begin
			image_width = STAND_WIDTH;
			image_height = STAND_HEIGHT;
			data_Out = data_out_stand;
		end
		
	end




	always_comb begin
		is_character = 1'b0;
		if (DrawX >= character_x && DrawX< character_x + image_width && DrawY >= character_y && DrawY< character_y + image_height )
			is_character = 1'b1;
	end
 
 endmodule
 

 
module  forward_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

logic [7:0] mem [0:70719];

initial
begin
	 $readmemh("images/Iori_new/iori_forward.txt", mem);
end

always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  backward_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

logic [7:0] mem [0:67409];

initial
begin
	 $readmemh("images/Iori_new/iori_backward.txt", mem);
end

always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  attack_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:60599];

initial
begin
	 $readmemh("images/Iori_new/iori_attack.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  stand_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:67931];

initial
begin
	 $readmemh("images/Iori_new/iori_stand.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  defense_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:8975];

initial
begin
	 $readmemh("images/Iori_new/iori_defense.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  hurt_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:40374];

initial
begin
	 $readmemh("images/Iori_new/iori_hurt.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
