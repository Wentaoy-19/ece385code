f//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,
				 output [7:0] LEDG,LEDR,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,      //SDRAM Clock
				 //Add for audio part
             input AUD_ADCDAT,
             input AUD_DACLRCK,
             input AUD_ADCLRCK,
             input AUD_BCLK,
             output logic I2C_SCLK, I2C_SDAT, AUD_XCK, AUD_DACDAT
                    );
    
    logic Reset_h, Clk;
    logic [7:0] keycode0,keycode1,keycode2,keycode3,keycode4,keycode5;
	 logic [47:0] keycodes;
	 logic [9:0] DrawX,DrawY;
	 logic is_ball,is_hp_frame,is_hp_bar1,is_hp_bar2,is_foreground,is_character1,is_character2,is_background,move_l1,move_r1,move_l2,move_r2,stand1,stand2,attack2,hurt1,hurt2,die1,die2;
	 logic [7:0] character1_data, character2_data, background_data,foreground_data,data_hp_frame,data_hp_bar1,data_hp_bar2;
	 logic [7:0] andy_frame_num, andy_state, iori_frame_num, iori_state; 
	 
     logic [18:0] character1_x, character2_x,distance_sub;
	  logic [18:0] HP1,HP2;
	  logic character1_die, character2_die;


     logic exist_character1, exist_character2, exist_background, exist_foreground,exist_hp,game_start,game_over,game_restart;
     logic [7:0] game_state;
	 logic character1_move_l, character1_move_r, character1_attack, character1_defense, character1_hurt, character1_attack_confirm;
	 logic character2_move_l, character2_move_r, character2_attack, character2_defense, character2_hurt, character2_attack_confirm;
    
	 assign keycodes = {keycode5,keycode4,keycode3,keycode2,keycode1,keycode0};
	 assign LEDG[3:0] = {exist_character1,exist_character2,exist_background,exist_foreground};
    assign distance_sub = character2_x - character1_x;
	 
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode0_export(keycode0), 
									  .keycode1_export(keycode1),
									  .keycode2_export(keycode2),
									  .keycode3_export(keycode3), 
									  .keycode4_export(keycode4),
									  .keycode5_export(keycode5),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.Clk(Clk),        
                                           .Reset(Reset_h),       
                                           .VGA_HS(VGA_HS),
                                           .VGA_VS(VGA_VS),      
                                           .VGA_CLK(VGA_CLK),    
                                           .VGA_BLANK_N(VGA_BLANK_N), 
                                           .VGA_SYNC_N(VGA_SYNC_N),         
                                           .DrawX(DrawX),       
                                           .DrawY(DrawY) );
    
    // Which signal should be frame_clk?
//    ball ball_instance(.Clk(Clk),               
//                        .Reset(Reset_h),  
//								.keycode(keycode),
//                         .frame_clk(VGA_VS),          
//               .DrawX(DrawX), .DrawY(DrawY),      
//               .is_ball(is_ball) );
andy andy_instance(.Clk(Clk), .Reset(Reset_h),              
                             .frame_clk(VGA_VS),       
               .DrawX(DrawX), .DrawY(DrawY),       
               .is_character(is_character1), 
               .exist_character1(exist_character1),
					.character2_x(character2_x),
					.character1_state(andy_state),
					.move_l1(move_l1),
					.move_r1(move_r1),
					.stand2(stand2),
					.hurt(hurt1),
					.character1_move_r(character1_move_r),
					.character1_move_l(character1_move_l),
                  .character1_hurt(character1_hurt),
					.data_Out(character1_data),
                  .character1_x(character1_x),
					.frame_num(andy_frame_num),
                    .game_state(game_state),
						  .character1_die(character1_die),
						  .HP_out(HP1),
						  .die1(die1)
);



iori iori_instance(.Clk(Clk), 
						 .Reset(Reset_h),              
                   .frame_clk(VGA_VS),       
                   .DrawX(DrawX), 
						 .DrawY(DrawY),       
                   .is_character(is_character2), 
                   .exist_character2(exist_character2),
						 .character1_x(character1_x),
					    .character2_state(iori_state),
                        .game_state(game_state),
								.die2(die2),
						 .move_l2(move_l2),
						 .move_r2(move_r2),
						 .stand1(stand1),
						 .attack(attack2),
						 .hurt(hurt2),
						 .character2_move_r(character2_move_r),
					    .character2_move_l(character2_move_l),
                   .character2_hurt(character2_hurt),
					    .data_Out(character2_data),
						 .HP_out(HP2),
						 .character2_die(character2_die),
                   .character2_x(character2_x),
					    .frame_num(iori_frame_num) 
);




background background_instance(.Clk(Clk),                
                             .Reset(Reset_h),              
                             .frame_clk(VGA_VS),        
									  
									 					
               .DrawX(DrawX), .DrawY(DrawY),     
               .is_background(is_background), 
					.data_Out(background_data));
    
	 
	 
color_mapper color_instance(
							  .is_character1(is_character1), 
							  .is_character2(is_character2),
							  .is_background(is_background), 
							  .is_foreground(is_foreground),
							  .is_hp_bar1(is_hp_bar1),
							  .is_hp_bar2(is_hp_bar2),
							  .is_hp_frame(is_hp_frame),
							  .is_ko(is_ko),
                       .DrawX(DrawX), .DrawY(DrawY),    
							  .character1_data(character1_data),
							  .character2_data(character2_data),
							  .background_data(background_data),
							  .ko_data(ko_data),
							  .data_hp_frame(data_hp_frame),
							  .data_hp_bar1(data_hp_bar1),
							  .data_hp_bar2(data_hp_bar2),
                              .foreground_data(foreground_data),
                       .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));
							  


andy_FSM andy_FSM(.Clk(Clk),                
            .Reset(Reset_h),              
             .frame_clk(VGA_VS), 
				 .character1_attack(character1_attack_confirm),
				 .character1_move_l(character1_move_l),
				 .character1_move_r(character1_move_r),
				 .move_l1(move_l1),
				 .move_r1(move_r1),
				 .character1_hurt(character1_hurt),
				 .character1_defend(character1_defense),
				 .character1_die(character1_die),
				 .stand1(stand1),
				 .hurt(hurt1),
				 .game_state(game_state),
                 .exist_character1(exist_character1),
				.state_out(andy_state), 
				.frame_num(andy_frame_num),
				.die1(die1)
                );

				
				
iori_FSM iori_FSM(.Clk(Clk),                
            .Reset(Reset_h),              
            .frame_clk(VGA_VS), 
				.character2_attack(character2_attack_confirm),
				.character2_move_l(character2_move_l),
				.character2_move_r(character2_move_r),
				.character2_hurt(character2_hurt),
				.character2_defense(character2_defense),
				.exist_character2(exist_character2),
				.move_l2(move_l2),
				.move_r2(move_r2),
				.stand2(stand2),
				.hurt(hurt2),
				.die2(die2),
				.attack(attack),
				.game_state(game_state),
				.character2_die(character2_die),
				.state_out(iori_state), 
				.frame_num(iori_frame_num));
				


							  
keycontroller keycontroller(
	.keycodes(keycodes), 
	.character1_move_l(character1_move_l),
	.character1_move_r(character1_move_r),
	.character1_attack(character1_attack),
	.character1_defense(character1_defense),
	.character2_move_l(character2_move_l),
	.character2_move_r(character2_move_r),
	.character2_attack(character2_attack),
	.character2_defense(character2_defense),
    .game_start(game_start),
    .game_restart(game_restart)
);
					
AH_judge AH_judge(
    .attack1(character1_attack),
    .attack2(character2_attack),
    .defend1(character1_defense),
    .defend2(character2_defense),
    .character1_x(character1_x),
    .character2_x(character2_x),
	 .game_state(game_state),

    .character1_hurt(character1_hurt), .character2_hurt(character2_hurt),
	 .character1_attack_confirm(character1_attack_confirm), .character2_attack_confirm(character2_attack_confirm)
);			


foreground foreground
(.Clk(Clk),                
                             .Reset(Reset_h),
										.exist_foreground(exist_foreground),
                             .frame_clk(VGA_VS),        
									  
									 					
               .DrawX(DrawX), .DrawY(DrawY),     
               .is_foreground(is_foreground), 
				.data_Out(foreground_data)
); 

assign game_over = character1_die | character2_die;

game_controller game_controller(
	 .Clk(Clk),
    .game_start(game_start), .game_over(game_over), .game_restart(game_restart),
    .Reset(Reset_h),
    .exist_character1(exist_character1), .exist_character2(exist_character2), .exist_background(exist_background),.exist_foreground(exist_foreground),.game_state(game_state),
	 .exist_hp(exist_hp),.exist_ko(exist_ko)
	 );  


hp_bar hp_bar(
.Clk(Clk),                
                .Reset(Reset_h),              
                .frame_clk(VGA_VS), 
                .exist_hp(exist_hp),       
									  					 					
               .DrawX(DrawX), .DrawY(DrawY), 
               .hp1(HP1), .hp2(HP2),    
               .is_hp_frame(is_hp_frame),
               .is_hp_bar1(is_hp_bar1), .is_hp_bar2(is_hp_bar2),
			      .data_hp_frame(data_hp_frame), .data_hp_bar1(data_hp_bar1), .data_hp_bar2(data_hp_bar2)
);

logic [7:0] ko_data;
logic exist_ko, is_ko;


ko ko
(.Clk(Clk),                
                             .Reset(Reset_h),              
                             .frame_clk(VGA_VS),        
									  .exist_ko(exist_ko),
									 					
               .DrawX(DrawX), .DrawY(DrawY),     
               .is_ko(is_ko), 
				.data_Out(ko_data)
); 





	 // ---------------- Add for Audio part -----------------
	logic  [16:0] Add;
	logic  [16:0] music_content;

        //Audio part wiring 
    audio audio1(.*, .Reset(Reset_h));
    music music1(.*);
    audio_interface music_int ( .LDATA(music_content), 
          .RDATA(music_content),
          .CLK(Clk),
          .Reset(Reset_h), 
          .INIT(INIT),
          .INIT_FINISH(INIT_FINISH),
          .adc_full(adc_full),
          .data_over(data_over),
          .AUD_MCLK(AUD_XCK),
          .AUD_BCLK(AUD_BCLK),     
          .AUD_ADCDAT(AUD_ADCDAT),
          .AUD_DACDAT(AUD_DACDAT),
          .AUD_DACLRCK(AUD_DACLRCK),
          .AUD_ADCLRCK(AUD_ADCLRCK),
          .I2C_SDAT(I2C_SDAT),
          .I2C_SCLK(I2C_SCLK),
          .ADCDATA(ADCDATA),
    );

	

    
    // Display keycode on hex display



    // HexDriver hex_inst_0 (keycodes[3:0], HEX0);
    // HexDriver hex_inst_1 (keycodes[7:4], HEX1);	
	//  HexDriver hex_inst_2 (keycodes[11:8], HEX2);	
    // HexDriver hex_inst_3 (keycodes[15:12], HEX3);	
    // HexDriver hex_inst_4 (keycodes[19:16], HEX4);	
    // HexDriver hex_inst_5 (keycodes[23:20], HEX5);	
    // HexDriver hex_inst_6 (keycodes[27:24], HEX6);	
    // HexDriver hex_inst_7 (keycodes[31:28], HEX7);	


//    HexDriver hex_inst_0 (HP2[3:0], HEX0);
//    HexDriver hex_inst_1 (HP2[7:4], HEX1);	
//	HexDriver hex_inst_2 (HP1[3:0], HEX4);	
//    HexDriver hex_inst_3 (HP1[7:4], HEX5);	
    // HexDriver hex_inst_5 (keycodes[23:20], HEX5);	
    // HexDriver hex_inst_6 (keycodes[27:24], HEX6);	
    // HexDriver hex_inst_7 (keycodes[31:28], HEX7);	
	 
    HexDriver hex_inst_0 (game_state[3:0], HEX0);
    HexDriver hex_inst_1 (game_state[7:4], HEX1);	

    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
