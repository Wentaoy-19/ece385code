//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
//module  color_mapper ( input              is_ball,            // Whether current pixel belongs to ball 
//                       input 					is_character,                                      //   or background (computed in ball.sv)
//                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
//                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
//                     );
//    
//    logic [7:0] Red, Green, Blue;
//    
//    // Output colors to VGA
//    assign VGA_R = Red;
//    assign VGA_G = Green;
//    assign VGA_B = Blue;
//		assign character_palette = '{24'800080, 24'h001000, 24'hF8F8F8,24'hD07840,24'h481800, 24'h803808, 24'hF0A868,24'hF8D0A0, 24'h303820, 24'h202810};
//											 
//    
//    // Assign color based on is_ball signal
//    always_comb
//    begin
//        if (is_ball == 1'b1) 
//        begin
//            // White ball
//            Red = 8'hff;
//            Green = 8'hff;
//            Blue = 8'hff;
//        end
//        else 
//        begin
//            // Background with nice color gradient
//            Red = 8'h3f; 
//            Green = 8'h00;
//            Blue = 8'h7f - {1'b0, DrawX[9:3]};
//        end
//    end 
//    
//endmodule



module  color_mapper ( 
                       input is_character1,  
							  input is_character2, 
							  input is_background, 
                       input [9:0] DrawX, DrawY,       
							  input logic [7:0] character1_data,
							  input logic [7:0] character2_data,
							  input logic [7:0] background_data,
                       output logic [7:0] VGA_R, VGA_G, VGA_B 
                     );
    
    logic [7:0] Red, Green, Blue;
	 logic [23:0] character1_color, character2_color,background_color;
	 logic [23:0] character1_palette [0:13];
	 logic [23:0] character2_palette [0:15];
	 logic [23:0] background_palette [0:205];
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 assign character1_palette ='{24'h800080, 24'hF8F8E8, 24'hA80000, 24'hA03008, 24'hE07038, 24'hF8A860, 24'hC8B078, 24'hA07810, 24'hE0B050, 24'hF8E098, 24'hF8E0B0, 24'h888860, 24'h404838, 24'h680018};
	 assign character2_palette ='{24'h800080, 24'h080008, 24'hF8F0F8, 24'h787880, 24'hC0B8C0, 24'h801808, 24'h500000, 24'hB85028, 24'hB02810, 24'hE03820, 24'hF09058, 24'hF8C080, 24'hF8F0B0, 24'h302838, 24'h201828, 24'h403848};
	 assign background_palette ='{24'h800080, 24'h221111, 24'h222211, 24'h111122, 24'h221122, 24'h112222, 24'hEEEEDD, 24'hEEDDEE, 24'hCCEEFF, 24'hEEFFFF, 24'h222222, 24'h333333, 24'h444444, 24'h555555, 24'h665555, 24'h666666, 24'h776666, 24'h777777, 24'h887777, 24'h888888, 24'h998888, 24'h999999, 24'hAA9999, 24'hAAAAAA, 24'hBBBBBB, 24'h666655, 24'h777766, 24'h888877, 24'h999988, 24'hAAAA99, 24'h556655, 24'h667766, 24'h778877, 24'h889988, 24'h667777, 24'h889999, 24'h99AAAA, 24'h666677, 24'h888899, 24'h665566, 24'h776677, 24'h887788, 24'hAA99AA, 24'h332222, 24'h443333, 24'h554444, 24'h553333, 24'h442222, 24'h664444, 24'h775555, 24'h886666, 24'h331111, 24'h552222, 24'h997777, 24'hAA8888, 24'h441111, 24'hBBAAAA, 24'hBB9999, 24'hEE4444, 24'h664433, 24'h775544, 24'h553322, 24'h774433, 24'h885544, 24'h996655, 24'h663322, 24'hAA7766, 24'h884433, 24'hAA5544, 24'hBB9988, 24'h662211, 24'h993322, 24'h772211, 24'hBB4433, 24'hCCAA99, 24'hCC9988, 24'hCC3322, 24'hDD5533, 24'hDD6644, 24'hEEBBAA, 24'h554433, 24'h443322, 24'h665544, 24'h997766, 24'hAA8877, 24'hBB8877, 24'hEEAA99, 24'hFF9977, 24'h776655, 24'h887766, 24'h998877, 24'hAA9988, 24'hBBAA99, 24'hAA7744, 24'hBB8844, 24'hCCBBAA, 24'hBB7733, 24'h885511, 24'hCC8833, 24'hAA5511, 24'hDD9955, 24'hEEDDCC, 24'hEECCAA, 24'h776644, 24'h554422, 24'h887755, 24'h998866, 24'h776633, 24'h998855, 24'h443311, 24'hAA9977, 24'h886633, 24'h554411, 24'hBBAA88, 24'hBBAA77, 24'h664411, 24'hAA8822, 24'h996611, 24'hAA7711, 24'hDDCC99, 24'hEECC66, 24'hEEDD99, 24'h777755, 24'hBBAA44, 24'h776611, 24'hEEBB22, 24'h333322, 24'h444433, 24'h555544, 24'h555533, 24'h444422, 24'h666644, 24'h888866, 24'h777744, 24'h555522, 24'h999977, 24'h999966, 24'hAAAA88, 24'hBBBBAA, 24'hBBBB99, 24'hBBBB77, 24'hCCCCAA, 24'hEEEEAA, 24'h889955, 24'h99AA66, 24'h88AA33, 24'hAACC33, 24'h445533, 24'h667755, 24'h889977, 24'h99AA88, 24'hAABB99, 24'hBBEE66, 24'hCCFF88, 24'hDDFFAA, 24'h446633, 24'h558844, 24'h223322, 24'h334433, 24'h445544, 24'hAABBAA, 24'hCCDDCC, 24'hCCEECC, 24'h66AA77, 24'hAACCBB, 24'h55AA99, 24'h223333, 24'h334444, 24'h445555, 24'h558888, 24'hAABBBB, 24'hAADDDD, 24'h557788, 24'h55AABB, 24'h3388AA, 24'h66DDEE, 24'h3399CC, 24'h445566, 24'h556677, 24'h778899, 24'h8899AA, 24'h5588AA, 24'h99BBCC, 24'h77AACC, 24'h66AADD, 24'hCCDDEE, 24'h7788BB, 24'h222233, 24'h333344, 24'h444455, 24'hAAAABB, 24'h332233, 24'h443344, 24'h554455, 24'hBBAABB, 24'hCCBBCC, 24'h442233, 24'h664455, 24'h886677, 24'hAA8899, 24'h774455, 24'h552233, 24'h996677, 24'h995566, 24'hBB5566, 24'hAA3344};
	 assign character1_color = character1_palette[character1_data];
	 assign character2_color = character2_palette[character2_data]; 
	 assign background_color = background_palette[background_data];
    
    always_comb
    begin
        if (is_character1 == 1'b1 && character1_data!=8'd0) 
        begin
            Red = character1_color[23:16];
            Green = character1_color[15:8];
            Blue = character1_color[7:0];
        end
		  
		  else if (is_character2 == 1'b1 && character2_data!=8'd0) 
        begin
            Red = character2_color[23:16];
            Green = character2_color[15:8];
            Blue = character2_color[7:0];
        end
		  
//		  else if(is_background == 1'b1)
//		  begin
//				Red = background_color[23:16];
//            Green = background_color[15:8];
//            Blue = background_color[7:0];
//		  end
		  
        else 
        begin
            Red = 8'h80; 
            Green = 8'h00;
            Blue = 8'h80;
        end
    end 
    
endmodule