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
	parameter [18:0] ATTACK_WIDTH = 19'd216;
	parameter [18:0] ATTACK_HEIGHT = 19'd97;

	logic [18:0] read_address,read_address_forward,read_address_backward;
	logic [18:0] character_x,character_y; 	
	logic [18:0] image_width, image_height;
	
	logic [18:0] current_state;
	
	logic [7:0] data_out_forward, data_out_backward;
	
	assign character_x = 19'd320;
	assign character_y = 19'd240; 
	
	assign read_address_forward = frame_num*FORWARD_WIDTH*FORWARD_HEIGHT+ (DrawX - character_x) + (DrawY - character_y)*FORWARD_WIDTH;  
	assign read_address_backward = frame_num*BACKWARD_WIDTH*BACKWARD_HEIGHT+ (DrawX - character_x) + (DrawY - character_y)*BACKWARD_WIDTH;  

//	assign read_address = frame_num*ATTACK_WIDTH*ATTACK_HEIGHT+ (DrawX - character_x) + (DrawY - character_y)*ATTACK_WIDTH;  
//	assign read_address = frame_num*BACKWARD_WIDTH*BACKWARD_HEIGHT+ (DrawX - character_x) + (DrawY - character_y)*BACKWARD_WIDTH;  


	
	
	forward_RAM forward_RAM(.read_address(read_address_forward),.Clk(Clk), .data_Out(data_out_forward) );
	backward_RAM backward_RAM(.read_address(read_address_backward),.Clk(Clk), .data_Out(data_out_backward) );

	assign current_state = 19'd1;
	always_comb 
	begin 
		image_width = FORWARD_WIDTH;
		image_height = FORWARD_HEIGHT;
		data_Out = data_out_forward;
		
		if(current_state == 19'b0)
		begin
			image_width = FORWARD_WIDTH;
			image_height = FORWARD_HEIGHT;
			data_Out = data_out_forward;
		end
		else if(current_state == 19'd1)
		begin
			image_width = BACKWARD_WIDTH;
			image_height = BACKWARD_HEIGHT;
			data_Out = data_out_backward;

		end	
	end




	always_comb begin
		is_character = 1'b0;
		if (DrawX >= character_x && DrawX<=character_x + image_width && DrawY >= character_y && DrawY<=character_y + image_height )
			is_character = 1'b1;
	end
 
 endmodule
 

 
module  forward_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

logic [7:0] mem [0:26774];

initial
begin
	 $readmemh("images/Andy/forward.txt", mem);
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

logic [7:0] mem [0:27539];

initial
begin
	 $readmemh("images/Andy/backward.txt", mem);
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
logic [7:0] mem [0:335231];

initial
begin
	 $readmemh("images/Andy/attack.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule

