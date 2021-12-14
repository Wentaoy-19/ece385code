module background
(input         Clk,                
                             Reset,              
                             frame_clk,        
									  
									 					
               input [9:0]   DrawX, DrawY,     
               output logic  is_background, 
					output logic [7:0] data_Out
); 
	parameter [18:0] SCREEN_HEIGHT =  19'd480;
   parameter [18:0] SCREEN_WIDTH = 19'd640;
	
	parameter [18:0] RESHAPE_WIDTH = 19'd640;
	parameter [18:0] RESHAPE_HEIGHT = 19'd480;

	logic [18:0] read_address;
	
	logic [18:0] background_x; 
	logic [18:0] background_y;
	
	assign background_x = 19'h0;
	assign background_y = 19'h0; 
	
	assign read_address =DrawX + DrawY*RESHAPE_WIDTH;
	background_RAM background_RAM(.read_address(read_address),.Clk(Clk), .data_Out(data_Out) );


	always_comb begin
		is_background = 1'b0;
		if (DrawX >= background_x && DrawX<=background_x + RESHAPE_WIDTH && DrawY >= background_y && DrawY<=background_y + RESHAPE_HEIGHT )
			is_background = 1'b1;
	end
 
 endmodule















module  background_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem [0:307200];

initial
begin
	 $readmemh("images/background00.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule