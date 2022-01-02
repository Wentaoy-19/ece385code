module ko
(input         Clk,                
                             Reset,              
                             frame_clk,        
									  exist_ko,
									 					
               input [9:0]   DrawX, DrawY,     
               output logic  is_ko, 
					output logic [7:0] data_Out
); 	
	parameter [18:0] R_WIDTH = 19'd71;
	parameter [18:0] R_HEIGHT = 19'd63;
    parameter [18:0] WIDTH = 4*R_WIDTH;
    parameter [18:0] HEIGHT = 4*R_HEIGHT;

	logic [18:0] read_address;
	logic [18:0] ko_x; 
	logic [18:0] ko_y;
	
	assign ko_x = 19'd180;
	assign ko_y = 19'd80; 
	
	assign read_address =(DrawX-ko_x)/4 + (DrawY-ko_y)/4*R_WIDTH;

	ko_RAM ko_RAM(.read_address(read_address),.Clk(Clk), .data_Out(data_Out) );
	always_comb begin
		is_ko = 1'b0;
		if (exist_ko && DrawX >= ko_x && DrawX < ko_x + WIDTH && DrawY >= ko_y && DrawY<ko_y + HEIGHT )
			is_ko = 1'b1;
	end
 
 endmodule



 module  ko_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

logic [7:0] mem [0:4472];

initial
begin
	 $readmemh("images/KO2.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule