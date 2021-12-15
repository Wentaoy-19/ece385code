module keycontroller(
	input [31:0] keycodes, 
	output character1_move_l,
	output character1_move_r,
	output character1_attack
);


	logic [7:0] key0, key1, key2, key3;
	assign key0 = keycodes[7:0]; 
	assign key1 = keycodes[15:8]; 
	assign key2 = keycodes[23:16];
	assign key3 = keycodes[31:24];
	
	parameter [7:0] key_move_l = 8'h04; 
	parameter [7:0] key_move_r = 8'h07;
	parameter [7:0] key_attack = 8'h1a;
	
	assign character1_move_l = (keycodes[15:8] == 8'h04) || (keycodes[7:0] == 8'h04)  || (keycodes[23:16] == 8'h04) ||(keycodes[31:24] == 8'h04);
	assign character1_move_r = (keycodes[15:8] == 8'h07) ||(keycodes[7:0] == 8'h07)  || (keycodes[23:16] == 8'h07) ||(keycodes[31:24] == 8'h07);
	assign character1_attack = (keycodes[15:8] == 8'h1a) || (keycodes[7:0] == 8'h1a) || (keycodes[23:16] == 8'h1a) ||(keycodes[31:24] == 8'h1a);

endmodule 