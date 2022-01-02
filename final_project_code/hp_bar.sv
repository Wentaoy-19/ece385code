module hp_bar(
    input         Clk,                
                Reset,              
                frame_clk, 
                exist_hp,       
									  					 					
               input [9:0]   DrawX, DrawY, 
               input [18:0]  hp1, hp2,    
               output logic  is_hp_frame,
               output logic is_hp_bar1, is_hp_bar2,
			    output logic [7:0] data_hp_frame, data_hp_bar1, data_hp_bar2
);


	parameter [18:0] SCREEN_HEIGHT =  19'd480;
    parameter [18:0] SCREEN_WIDTH = 19'd640;
	
    parameter [18:0] FRAME_WIDTH = 19'd620;
    parameter [18:0] FRAME_HEIGHT = 19'd75;
    parameter [18:0] HP1_WIDTH = 19'd199;
    parameter [18:0] HP1_HEIGHT = 19'd20;
    parameter [18:0] HP2_WIDTH = 19'd200;
    parameter [18:0] HP2_HEIGHT = 19'd20;
    parameter [18:0] TOTAL_HP = 19'd20;
    parameter [18:0] HP_STEP = 19'd10;

	logic [18:0] read_address_frame, read_address_hp1, read_address_hp2;
	logic [18:0] frame_x, frame_y, hp1_x, hp1_y, hp2_x, hp2_y, hp1_len, hp2_len ; 
   logic [7:0] dataout_frame, dataout_hp1, dataout_hp2;

    assign frame_x = 19'd10;
    assign frame_y = 19'd10;
    assign hp1_len = 10*hp1; 
    assign hp2_len = 10*hp2;
	 assign hp2_x = frame_x + 19'd545;
	 assign hp2_y = frame_y + 19'd28;
	 assign hp1_x = frame_x + 19'd76;
	 assign hp1_y = frame_y + 19'd28;
	
	 assign read_address_frame =(DrawX-frame_x) + (DrawY - frame_y)*FRAME_WIDTH;
    assign read_address_hp1 = (DrawX-hp1_x) + (DrawY - hp1_y)*HP1_WIDTH;
    assign read_address_hp2 = (DrawX-hp2_x) + (DrawY - hp2_y)*HP2_WIDTH;

	frame_RAM frame_RAM(.read_address(read_address_frame),.Clk(Clk), .data_Out(dataout_frame) );
	hp1_RAM hp1_RAM(.read_address(read_address_hp1),.Clk(Clk), .data_Out(dataout_hp1) );
	hp2_RAM hp2_RAM(.read_address(read_address_hp2),.Clk(Clk), .data_Out(dataout_hp2) );

    assign data_hp_bar1 = dataout_hp1;
    assign data_hp_bar2 = dataout_hp2;
    assign data_hp_frame = dataout_frame;
  

	always_comb begin
		is_hp_frame = 1'b0;
        is_hp_bar1 = 1'b0;
        is_hp_bar2 = 1'b0;

		if ( exist_hp && DrawX >= frame_x && DrawX< frame_x + FRAME_WIDTH && DrawY >= frame_y && DrawY< frame_y + FRAME_HEIGHT )
			is_hp_frame = 1'b1;

        if ( exist_hp && DrawX >= hp1_x && DrawX< hp1_x + hp1_len && DrawY >= hp1_y && DrawY< hp1_y + HP1_HEIGHT )
            is_hp_bar1 = 1'b1;

        if ( exist_hp && DrawX >=  hp2_x - hp2_len && DrawX< hp2_x && DrawY >= hp2_y && DrawY< hp2_y + HP2_HEIGHT )
            is_hp_bar2 = 1'b1;

	end

endmodule


module  frame_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

logic [7:0] mem [0:46499];

initial
begin
	 $readmemh("images/hp_frame.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule



module  hp1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

logic [7:0] mem [0:3979];
initial
begin
	 $readmemh("images/hp_left.txt", mem);
end
always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end
endmodule

module  hp2_RAM
(
		input [18:0] read_address,
		input Clk,
		output logic [7:0] data_Out
);

logic [7:0] mem [0:3999];

initial
begin
	 $readmemh("images/hp_right.txt", mem);
end
always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule


