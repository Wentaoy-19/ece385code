/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

 
module iori
(input         Clk,// 50 MHz clock
               Reset,              // Active-high reset signal
               frame_clk,          // The clock indicating a new frame (~60Hz)
									  
									  
					input [7:0]   frame_num,
					input [7:0]   character2_state,
					input logic [18:0] character1_x,
					
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_character, 
					output logic [7:0] data_Out,
					output logic [18:0] character2_x
); 
	parameter [18:0] SCREEN_WIDTH =  19'd480;
   parameter [18:0] SCREEN_LENGTH = 19'd640;
	
	parameter [18:0] FORWARD_WIDTH = 19'd68;
	parameter [18:0] FORWARD_HEIGHT = 19'd104;
	parameter [18:0] BACKWARD_WIDTH = 19'd70;
	parameter [18:0] BACKWARD_HEIGHT = 19'd106;
	parameter [18:0] ATTACK_WIDTH = 19'd100;
	parameter [18:0] ATTACK_HEIGHT = 19'd100;
	parameter [18:0] STAND_WIDTH = 19'd74;
	parameter [18:0] STAND_HEIGHT = 19'd102;
	parameter [18:0] DEFENSE_WIDTH = 19'd88;
	parameter [18:0] DEFENSE_HEIGHT = 19'd102;
	parameter [18:0] HURT_WIDTH = 19'd84;
	parameter [18:0] HURT_HEIGHT = 19'd94; 
	
	
	parameter [18:0] R_FORWARD_WIDTH = 19'd34;
	parameter [18:0] R_FORWARD_HEIGHT = 19'd52;
	parameter [18:0] R_ATTACK_WIDTH = 19'd50;
	parameter [18:0] R_ATTACK_HEIGHT = 19'd50;
	parameter [18:0] R_BACKWARD_WIDTH = 19'd35;
	parameter [18:0] R_BACKWARD_HEIGHT = 19'd53;	
	parameter [18:0] R_DEFENSE_WIDTH = 19'd44;
	parameter [18:0] R_DEFENSE_HEIGHT = 19'd51;
	parameter [18:0] R_HURT_WIDTH = 19'd42;
	parameter [18:0] R_HURT_HEIGHT = 19'd47; 
	parameter [18:0] R_STAND_WIDTH = 19'd37;
	parameter [18:0] R_STAND_HEIGHT = 19'd51;
	
	parameter [18:0] CHARACTER_WIDTH = 19'd99;
	

	logic [18:0] read_address,read_address_forward,read_address_backward,read_address_stand,read_address_attack,read_address_defense,read_address_hurt;
	logic [18:0] character_x,character_y,character_x_in, character_y_in; 	
	logic [18:0] image_width, image_height;	
	logic [7:0] data_out_forward, data_out_backward,data_out_attack,data_out_stand,data_out_defense,data_out_hurt;
	
	assign character_x = 19'd400;
	assign character_y = 19'd200; 
	assign character2_x = character_x;
	
	enum logic [7:0] {state_stand,state_attack, state_movel, state_mover, state_defense, state_hurt} state_in;
	
	assign read_address_backward = frame_num*R_BACKWARD_WIDTH*R_BACKWARD_HEIGHT+ (DrawX - character_x)/2 + (DrawY - character_y)/2*R_BACKWARD_WIDTH;  
	assign read_address_attack = frame_num*R_ATTACK_WIDTH*R_ATTACK_HEIGHT+ (DrawX - character_x)/2 + (DrawY - character_y)/2*R_ATTACK_WIDTH;  
	assign read_address_stand = frame_num*R_STAND_WIDTH*R_STAND_HEIGHT + (DrawX - character_x)/2 + (DrawY - character_y)/2*R_STAND_WIDTH;
	assign read_address_defense = frame_num*R_DEFENSE_WIDTH*R_DEFENSE_HEIGHT + (DrawX - character_x)/2 + (DrawY - character_y)/2*R_DEFENSE_WIDTH;
	assign read_address_hurt = frame_num*R_HURT_WIDTH*R_HURT_HEIGHT + (DrawX - character_x)/2 + (DrawY - character_y)/2*R_HURT_WIDTH;
	assign read_address_forward = frame_num*R_FORWARD_WIDTH*R_FORWARD_HEIGHT+ (DrawX - character_x)/2 + (DrawY - character_y)/2*R_FORWARD_WIDTH;  
	
	
	iori_forward_RAM iori_forward_RAM(.read_address(read_address_forward),.Clk(Clk), .data_Out(data_out_forward) );
	iori_backward_RAM iori_backward_RAM(.read_address(read_address_backward),.Clk(Clk), .data_Out(data_out_backward) );
	iori_stand_RAM iori_stand_RAM(.read_address(read_address_stand),.Clk(Clk), .data_Out(data_out_stand) );
	iori_attack_RAM iori_attack_RAM(.read_address(read_address_attack),.Clk(Clk), .data_Out(data_out_attack) );
	iori_defense_RAM iori_defense_RAM(.read_address(read_address_defense),.Clk(Clk), .data_Out(data_out_defense) );
	iori_hurt_RAM iori_hurt_RAM(.read_address(read_address_hurt),.Clk(Clk), .data_Out(data_out_hurt) );
	
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
 

 
module  iori_forward_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

logic [7:0] mem [0:17679];

initial
begin
	 $readmemh("images/Iori_resize/iori_forward.txt", mem);
end

always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  iori_backward_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

logic [7:0] mem [0:16694];

initial
begin
	 $readmemh("images/Iori_resize/iori_backward.txt", mem);
end

always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  iori_attack_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:14999];

initial
begin
	 $readmemh("images/Iori_resize/iori_attack.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  iori_stand_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:16892];

initial
begin
	 $readmemh("images/Iori_resize/iori_stand.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  iori_defense_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:2243];

initial
begin
	 $readmemh("images/Iori_resize/iori_defense.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  iori_hurt_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:9869 ];

initial
begin
	 $readmemh("images/Iori_resize/iori_hurt.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
