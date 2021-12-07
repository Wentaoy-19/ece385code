module datapath(
	input logic Clk,
	input logic Reset_ah, Run_ah,
	input logic LD_MAR,LD_MDR,LD_IR,LD_BEN,LD_CC,LD_REG,LD_PC,
	input logic GatePC, GateMDR, GateALU,GateMARMUX,
	input logic[1:0] PCMUX,ADDR2MUX,ALUK,
	input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
	input logic MIO_EN,
	input logic[15:0] MDR_In,S,
	output logic[15:0] MAR,IR,MDR, PC, 
	output logic BEN
); 	

logic[15:0] BUS;
logic[15:0] MDR_input,MDR_output, MAR_output, ALU_output, PC_output, MARMUX_output,IR_output,IR_input; 
logic[15:0] sr1out,sr2out,IMME;



reg_parallel_16 MDR_unit(.Clk(Clk),.Load(LD_MDR),.reset(Reset_ah),.D(MDR_input),.Data_Out(MDR_output));
reg_parallel_16 MAR_unit(.Clk(Clk),.Load(LD_MAR),.reset(Reset_ah),.D(BUS),.Data_Out(MAR_output));
reg_parallel_16 IR_unit(.Clk(Clk),.Load(LD_IR),.reset(Reset_ah),.D(IR_input),.Data_Out(IR_output));

BUS_select bus_select(.MDR2BUS(MDR_output), .ALU2BUS(ALU_output),.PC2BUS(PC_output),.MARMUX2BUS(MARMUX_output),.GateMDR(GateMDR),.GateALU(GateALU),.GatePC(GatePC),.GateMARMUX(GateMARMUX),.BUS(BUS));
PC_module PC_unit(.Clk(Clk), .LD_PC(LD_PC),.PCMUX(PCMUX),.Data_from_BUS(BUS),.Data_from_addrmux_to_PC(MARMUX_output),.DataOut(PC_output),.reset(Reset_ah),.run(Run_ah),.S(S)); 
ADDRMUX addrmux(.IR(IR_output),.ADDR2MUX(ADDR2MUX),.ADDR1MUX(ADDR1MUX),.data_from_SR1OUT(sr1out), .data_from_PC(PC_output),.Data_Out(MARMUX_output), .SEXT(IMME),.Data_to_controller(),.Data_to_BEN()); 
ALU alu(.SR1OUT(sr1out), .SR2OUT(sr2out),.IMME(IMME),.sr2mux(SR2MUX),.ALUK(ALUK),.OUT(ALU_output));
reg_file regfile(.Clk(Clk),.reset(Reset_ah),.BUS(BUS),.IR11_9(IR_output[11:9]),.IR8_6(IR_output[8:6]),.SR2(IR_output[2:0]),.DR(DRMUX),.SR1(SR1MUX),.LD_REG(LD_REG),.SR1OUT(sr1out),.SR2OUT(sr2out));
ben_module ben_module(.Clk(Clk),.reset(Reset_ah),.BUS(BUS),.LD_CC(LD_CC),.LD_BEN(LD_BEN),.IR11_9(IR_output[11:9]),.BEN(BEN));

assign MDR = MDR_output;
assign MAR = MAR_output;
assign PC = PC_output;
// assign IR_input = Reset_ah ? 16'b0 : BUS; 
assign IR_input = BUS;
assign IR = IR_output; 
// assign IR5 = IR_output[5];
// assign IR11 = IR_output[11];
assign MDR_input = MIO_EN ? BUS : MDR_In;

// always_comb begin
//     if(MIO_EN)
//         MDR_input = MDR_In;
//     else
//         MDR_input = BUS;	  
// end
endmodule


module BUS_select(
    input logic[15:0] MDR2BUS, ALU2BUS, PC2BUS, MARMUX2BUS,
    input logic GateMDR, GateALU, GatePC, GateMARMUX,
    output logic[15:0] BUS
);
    always_comb begin
        if(GateMDR)
            BUS = MDR2BUS;
        else if (GateALU)
            BUS = ALU2BUS;
        else if (GatePC)
            BUS = PC2BUS;
        else if (GateMARMUX)
            BUS = MARMUX2BUS; 
        else  
            BUS = 16'b0;      
    end
endmodule


			

	
	
module PC_module (
		input logic Clk,
		input logic LD_PC,
		input logic reset,
		input logic run,
		input logic [1:0] PCMUX,
		input logic [15:0] Data_from_BUS,
		input logic [15:0] Data_from_addrmux_to_PC,S,
		output logic [15:0] DataOut
);

	logic [15:0] Data_from_PCMUX, PCplus1,dataout_mid;	
	
	reg_parallel_16 REG_PC(.Clk(Clk), .Load(LD_PC),.reset(reset), .D(dataout_mid), .Data_Out(DataOut));
	
	mux4to1bit16 PCmultiplexer(.Din1(PCplus1), .Din2(Data_from_addrmux_to_PC), .Din3(Data_from_BUS),.Din4(),.select(PCMUX), .Dout(dataout_mid)); 
	
	assign PCplus1 = DataOut + 16'b1;
	
//	counter16bit counter(.Clk(Clk),.Din(DataOut), .Dout(PCplus1));
	
//	assign Data_from_PCMUX = ~run ? S : dataout_mid;
	
	// always_comb
	// 	begin
	// 		if(reset)
	// 			Data_from_PCMUX = 16'b0;
	// 		else
	// 			Data_from_PCMUX = dataout_mid;
	// 	end
		
	
endmodule
//
//module PC_module (
//  input logic Clk,
//  input logic LD_PC,
//  input logic reset,
//  input logic run,
//  input logic [1:0] PCMUX,
//  input logic [15:0] Data_from_BUS,
//  input logic [15:0] Data_from_addrmux_to_PC,S,
//  output logic [15:0] DataOut
//);
//
// logic [15:0] Data_from_PCMUX, PCplus1, dataout_mid; 
// 
// reg_parallel_16 REG_PC(.Clk(Clk), .Load(LD_PC),.reset(reset), .D(dataout_mid), .Data_Out(DataOut));
// 
// mux4to1bit16 PCmultiplexer(.Din1(PCplus1), .Din2(Data_from_addrmux_to_PC), .Din3(Data_from_BUS),.Din4(),.select(PCMUX), .Dout(dataout_mid)); 
// 
// //assign PCplus1 = DataOut + 16'b1;
// 
// counter16bit incrementer(.Din(DataOut), .Dout(PCplus1));
// 
//// assign Data_from_PCMUX = ~run ? S : dataout_mid;
// 
// // always_comb
// //  begin
// //   if(reset)
// //    Data_from_PCMUX = 16'b0;
// //   else
// //    Data_from_PCMUX = dataout_mid;
// //  end
//  
// 
//endmodule
	
	
	
	
	
	
	