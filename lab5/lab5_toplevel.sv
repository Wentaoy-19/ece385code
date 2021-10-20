/*  Date Created: Mon Jan 25 2015.
 *  Written to correspond with the spring 2016 lab manual.
 *
 *  ECE 385 Lab 4 (adders) template code.  This is the top level entity which
 *  connects an adder circuit to LEDs and buttons on the device.  It also
 *  declares some registers on the inputs and outputs of the adder to help
 *  generate timing information (fmax) and multiplex the DE115's 16 switches
 *  onto the adder's 32 inputs.
 *
 *	 Make sure you instantiate only one of the modules for each demo! 
 *  See section called module instatiation below.
 

/* Module declaration.  Everything within the parentheses()
 * is a port between this module and the outside world */
 
module lab5_toplevel
(
	input logic Clk, 
	input logic Run, 
	input logic Reset,
	input logic ClearA_LoadB,
	input logic[7:0]	S, 

	output logic[6:0] AhexU, 
	output logic[6:0] AhexL, 
	output logic[6:0] BhexU, 
	output logic[6:0] BhexL,
	output logic[7:0] Aval, 
	output logic[7:0] Bval,
	output logic X
); 		
    
    /* Declare Internal Wires
     * Wheather an internal logic signal becomes a register or wire depends
     * on if it is written inside an always_ff or always_comb block respectivly */
    logic[6:0]      Ahex0_comb;
    logic[6:0]      Ahex1_comb;
    logic[6:0]      Bhex0_comb;
    logic[6:0]      Bhex1_comb;

    logic [7:0] S_S;
	 logic run_s, clrld_s,reset_s ; 
    logic clr_ld,shift,add,sub,m,clear_a; 
	 
    control controller(.Reset(reset_s),.ClearA_LoadB(clrld_s),.Clk(Clk),.Run(run_s),.Clr_Ld(clr_ld),.Shift(shift),.Add(add),.Sub(sub),.cleara(clear_a),.M(m));
    arithmetic arithmetic_unit(.Clr_Ld(clr_ld),.Shift(shift),.Add(add),.Sub(sub),.cleara(clear_a),.S(S_S),.Clk(Clk),.Reset(reset_s),.Sum({Aval,Bval}),.M(m),.X(X));
	 
    // /* Behavior of registers A, B, Sum, and CO */
    // always_ff @(posedge Clk) begin
        
    //     if (!Reset) begin
    //         // if reset is pressed, clear the adder's input registers
    //         A <= 16'h0000;
    //         B <= 16'h0000;
    //         Sum <= 16'h0000;
    //         CO <= 1'b0;
    //     end else if (!LoadB) begin
    //         // If LoadB is pressed, copy switches to register B
    //         B <= SW;
    //     end else begin
    //         // otherwise, continuously copy switches to register A
    //         A <= SW;
    //     end
        
    //     // transfer sum and carry-out from adder to output register
    //     // every clock cycle that Run is pressed
    //     if (!Run) begin
    //         Sum <= Sum_comb;
    //         CO <= CO_comb;
    //     end
    //         // else, Sum and CO maintain their previous values
        
    // end


    always_ff @(posedge Clk) begin
        AhexL <= Ahex0_comb;
        AhexU <= Ahex1_comb;
        BhexL <= Bhex0_comb;
        BhexU <= Bhex1_comb;
    end
    
    /* Module instantiation
	  * You can think of the lines below as instantiating objects (analogy to C++).
     * The things with names like Ahex0_inst, Ahex1_inst... are like a objects
     * The thing called HexDriver is like a class
     * Each time you instantate an "object", you consume physical hardware on the FPGA
     * in the same way that you'd place a 74-series hex driver chip on your protoboard 
     * Make sure only *one* adder module (out of the three types) is instantiated*/
	  

	  
    sync S_sync[7:0] (Clk, S, S_S);
    sync botton_sync[2:0] (Clk, {~Run,~ClearA_LoadB,~Reset}, {run_s,clrld_s,reset_s});
	
	 
	 
    HexDriver Ahex0_inst
    (
        .In0(Aval[3:0]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(Ahex0_comb)
    );
    
    HexDriver Ahex1_inst
    (
        .In0(Aval[7:4]),
        .Out0(Ahex1_comb)
    );
    
    HexDriver Bhex0_inst
    (
        .In0(Bval[3:0]),
        .Out0(Bhex0_comb)
    );
    
    HexDriver Bhex1_inst
    (
        .In0(Bval[7:4]),
        .Out0(Bhex1_comb)
    );
    
endmodule
