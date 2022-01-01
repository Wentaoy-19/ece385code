module keycontroller(
	input [47:0] keycodes, 
	output character1_move_l,
	output character1_move_r,
	output character1_attack,
	output character2_move_l,
	output character2_move_r,
	output character2_attack
);


	logic [7:0] key0, key1, key2, key3, key4, key5;
	assign key0 = keycodes[7:0]; 
	assign key1 = keycodes[15:8]; 
	assign key2 = keycodes[23:16];
	assign key3 = keycodes[31:24];
	assign key4 = keycodes[39:32];
	assign key5 = keycodes[47:40];
	
	parameter [7:0] key_move_l = 8'h04; 
	parameter [7:0] key_move_r = 8'h07;
	parameter [7:0] key_attack = 8'h1a;
	parameter [7:0] key_move_l2 = 8'h50;
	parameter [7:0] key_move_r2 = 8'h4f;
	parameter [7:0] key_attack2 = 8'h52;
	
	assign character1_move_l = (key0 == key_move_l) || (key1 == key_move_l)  || (key2 == key_move_l) ||(key3 == key_move_l) ||(key4 == key_move_l)|| (key5 == key_move_l);
	assign character1_move_r = (key0 == key_move_r) || (key1 == key_move_r)  || (key2 == key_move_r) ||(key3 == key_move_r) ||(key4 == key_move_r)|| (key5 == key_move_r);
	assign character1_attack = (key0 == key_attack) || (key1 == key_attack)  || (key2 == key_attack) ||(key3 == key_attack) ||(key4 == key_attack)|| (key5 == key_attack);
	
	assign character2_move_l = (key0 == key_move_l2) || (key1 == key_move_l2)  || (key2 == key_move_l2) ||(key3 == key_move_l2) ||(key4 == key_move_l2)|| (key5 == key_move_l2);
	assign character2_move_r = (key0 == key_move_r2) || (key1 == key_move_r2)  || (key2 == key_move_r2) ||(key3 == key_move_r2) ||(key4 == key_move_r2)|| (key5 == key_move_r2);
	assign character2_attack = (key0 == key_attack2) || (key1 == key_attack2)  || (key2 == key_attack2) ||(key3 == key_attack2) ||(key4 == key_attack2)|| (key5 == key_attack2);
	
	
	
endmodule 