module foreground
(input         Clk,                
                             Reset,              
                             frame_clk,        
									  
									 					
               input [9:0]   DrawX, DrawY,     
               output logic  is_foreground, 
					output logic [7:0] data_Out
); 
	parameter [18:0] SCREEN_HEIGHT =  19'd480;
   parameter [18:0] SCREEN_WIDTH = 19'd640;
	
	parameter [18:0] RESHAPE_WIDTH = 19'd320;
	parameter [18:0] RESHAPE_HEIGHT = 19'd240;

	logic [18:0] read_address;
	
	logic [18:0] foreground_x; 
	logic [18:0] foreground_y;
	
	assign foreground_x = 19'h0;
	assign foreground_y = 19'h0; 
	
	assign read_address =DrawX/2 + DrawY/2*RESHAPE_WIDTH;
	foreground_RAM foreground_RAM(.read_address(read_address),.Clk(Clk), .data_Out(data_Out) );


	always_comb begin
		is_foreground = 1'b0;
		if (DrawX >= foreground_x && DrawX<=foreground_x + SCREEN_WIDTH && DrawY >= foreground_y && DrawY<=foreground_y + SCREEN_HEIGHT )
			is_foreground = 1'b1;
	end
 
 endmodule



 module  foreground_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

logic [7:0] mem [0:76799];

initial
begin
	 $readmemh("images/foreground.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule