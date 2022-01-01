module keycontroller(
	input [47:0] keycodes, 
	output character1_move_l,
	output character1_move_r,
	output character1_attack,
	output character1_defense,
	output character2_move_l,
	output character2_move_r,
	output character2_attack,
	output character2_defense,
	output game_start,game_restart
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
	parameter [7:0] key_defense = 8'h16;
	
	parameter [7:0] key_move_l2 = 8'h50;
	parameter [7:0] key_move_r2 = 8'h4f;
	parameter [7:0] key_attack2 = 8'h52;
	parameter [7:0] key_defense2 = 8'h51;
	parameter [7:0] key_gamestart = 8'd44;
	parameter [7:0] key_gamerestart = 8'd44;
	
//	parameter [7:0] key_hurt = 8'h0d;
	
	assign character1_move_l = (key0 == key_move_l) || (key1 == key_move_l)  || (key2 == key_move_l) ||(key3 == key_move_l) ||(key4 == key_move_l)|| (key5 == key_move_l);
	assign character1_move_r = (key0 == key_move_r) || (key1 == key_move_r)  || (key2 == key_move_r) ||(key3 == key_move_r) ||(key4 == key_move_r)|| (key5 == key_move_r);
	assign character1_attack = (key0 == key_attack) || (key1 == key_attack)  || (key2 == key_attack) ||(key3 == key_attack) ||(key4 == key_attack)|| (key5 == key_attack);
	
	assign character2_move_l = (key0 == key_move_l2) || (key1 == key_move_l2)  || (key2 == key_move_l2) ||(key3 == key_move_l2) ||(key4 == key_move_l2)|| (key5 == key_move_l2);
	assign character2_move_r = (key0 == key_move_r2) || (key1 == key_move_r2)  || (key2 == key_move_r2) ||(key3 == key_move_r2) ||(key4 == key_move_r2)|| (key5 == key_move_r2);
	assign character2_attack = (key0 == key_attack2) || (key1 == key_attack2)  || (key2 == key_attack2) ||(key3 == key_attack2) ||(key4 == key_attack2)|| (key5 == key_attack2);
	
//	assign character1_hurt = (key0 == key_hurt) || (key1 == key_hurt)  || (key2 == key_hurt) ||(key3 == key_hurt) ||(key4 == key_hurt)|| (key5 == key_hurt);
	assign character1_defense = (key0 == key_defense) || (key1 == key_defense)  || (key2 == key_defense) ||(key3 == key_defense) ||(key4 == key_defense)|| (key5 == key_defense);

	assign character2_defense = (key0 == key_defense2) || (key1 == key_defense2)  || (key2 == key_defense2) ||(key3 == key_defense2) ||(key4 == key_defense2)|| (key5 == key_defense2);
	assign game_start = (key0 == key_gamestart) || (key1 == key_gamestart)  || (key2 == key_gamestart) ||(key3 == key_gamestart) ||(key4 == key_gamestart)|| (key5 == key_gamestart);
	assign game_restart = (key0 == key_gamerestart) || (key1 == key_gamerestart)  || (key2 == key_gamerestart) ||(key3 == key_gamerestart) ||(key4 == key_gamerestart)|| (key5 == key_gamerestart);

	
endmodule 