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
	
	parameter [18:0] RESHAPE_LENGTH = 19'd51;
	parameter [18:0] RESHAPE_WIDTH = 19'd105;

	logic [18:0] read_address;
	
	logic [18:0] character_x; 
	logic [18:0] character_y;
	
	assign character_x = 19'h0;
	assign character_y = 19'h0; 
	
	assign read_address = frame_num*RESHAPE_LENGTH*RESHAPE_WIDTH+DrawX + DrawY*RESHAPE_LENGTH;  
	

	
	
	caojiji_RAM caojiji_RAM(.read_address(read_address),.Clk(Clk), .data_Out(data_Out) );


	always_comb begin
		is_character = 1'b0;
		if (DrawX >= character_x && DrawX<=character_x + RESHAPE_LENGTH && DrawY >= character_y && DrawY<=character_y + RESHAPE_WIDTH )
			is_character = 1'b1;
	end
 
 endmodule
 

 
module  caojiji_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:26774];

initial
begin
	 $readmemh("images/my_image.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
