module datapath(
	input logic Clk,
	input logic Reset_ah, Continue_ah, Run_ah, 
	input logic BEN,LD_MAR,LD_MDR,LD_IR,LD_BEN,LD_CC,LD_REG,LD_PC,LD_LED,
	input logic GatePC, GateMDR, GateALU,GateMARMUX,
	input logic[1:0] PCMUX,ADDR2MUX,ALUK,
	input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
	input logic MIO_EN,
	input logic[15:0] MDR_In,
	output logic[15:0] MAR,IR,MDR, PC
); 	//TODO: Clearify the pins 

logic[15:0] BUS;
logic[15:0] MDR_input,MDR_output, MAR_output, ALU_output, PC_output, MARMUX_output,IR_output,IR_input; 


reg_parallel_16 MDR_unit(.Clk(Clk),.Load(LD_MDR),.D(MDR_input),.Data_Out(MDR_output));
reg_parallel_16 MAR_unit(.Clk(Clk),.Load(LD_MAR),.D(BUS),.Data_Out(MAR_output));
reg_parallel_16 IR_unit(.Clk(Clk),.Load(LD_IR|Reset_ah),.D(IR_input),.Data_Out(IR_output));

BUS_select bus_select(.MDR2BUS(MDR_output), .ALU2BUS(ALU_output),.PC2BUS(PC_output),.MARMUX2BUS(MARMUX_output),.GateMDR(GateMDR),.GateALU(GateALU),.GatePC(GatePC),.GateMARMUX(GateMARMUX),.BUS(BUS));
PC_module PC_unit(	.Clk(Clk), .LD_PC(LD_PC),.PCMUX(PCMUX),.Data_from_BUS(BUS),.Data_from_addrmux_to_PC(),.DataOut(PC_output),.reset(Reset_ah));
assign MDR = MDR_output;
assign MAR = MAR_output;
assign PC = PC_output;
assign IR_input = Reset_ah ? 16'b0 : BUS;
assign IR = IR_output;
	


always_comb begin
    if(MIO_EN)
        MDR_input = MDR_In;
    else
        MDR_input = BUS;
		  
end
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
		input logic Clk, Reset_ah,
		input logic LD_PC,
		input logic reset,
		input logic [1:0] PCMUX,
		input logic [15:0] Data_from_BUS,
		input logic [15:0] Data_from_addrmux_to_PC,
		output logic [15:0] DataOut
);

	logic [15:0] Data_from_PCMUX, PCplus1,dataout_mid;	
	
	reg_parallel_16 REG_PC(.Clk(Clk), .Load(LD_PC | reset), .D(Data_from_PCMUX), .Data_Out(DataOut));
	
	mux4to1bit16 PCmultiplexer(.Din1(PCplus1), .Din2(Data_from_BUS), .Din3(Data_from_addrmux_to_PC),.Din4(),.select(PCMUX), .Dout(dataout_mid));
	
	counter16bit counter(.Clk(Clk),.Din(DataOut), .Dout(PCplus1));
	
	always_comb
		begin
			if(reset)
				Data_from_PCMUX = 16'b0;
			else
				Data_from_PCMUX = dataout_mid;
		end
		
	
endmodule
	
	
	
	
	
	
	